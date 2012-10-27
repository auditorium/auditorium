class NotificationObserver < ActiveRecord::Observer
  observe :user,:post, :rating, :course, :course_membership, :lecture_membership, :faculty_membership

  def deliver_email_notification(post, user)
    email_setting = EmailSetting.find_by_user_id(user.id)

    if email_setting 
      if email_setting.emails_for_subscribtions and membership = CourseMembership.find_by_user_id_and_course_id(user.id, post.course.id) 
        membership.receive_emails  
      else
        email_setting.notification_when_author
      end  
    else
      true
    end
  end

  def after_create(model)
    # code to send confirmation email...
    case model.class.name
      when 'Post'
        post = model

        # change latest activity of origin
        post.origin.last_activity = DateTime.now
        post.origin.save

        if post.origin.is_private?
          receivers = post.course.moderators
          receivers << post.origin.author
          receivers = receivers.uniq
        else
          receivers = post.course.users
          receivers += post.origin.all_authors.to_a
          receivers = receivers.uniq
        end

        receivers.delete_if {|receiver| receiver.id == post.author_id}
        sender = post.author

        receivers.each do |receiver|
          notification = Notification.create!(:receiver => receiver, :sender => sender, :notifyable_id => post.id, :notifyable_type => post.class.name)
          
          # send emails to subscribers
          AuditoriumMailer.update_in_course(receiver, post).deliver if deliver_email_notification(post, receiver)
        end
      when 'Course'
        course = model
        if !course.approved?
          admins = User.where(:admin => true)
          admins.each do |admin|
            AuditoriumMailer.new_course_to_approve(course, admin).deliver  
          end
        end
      # when 'User'
      #   user = model
      #   # add membership to support course
      #   course = Course.find_by_name('Support Center')
      #   membership = CourseMembership.new(:user_id => user.id, :course_id => course.id, :membership_type => 'member') if !course.nil?
    end
  end
end
