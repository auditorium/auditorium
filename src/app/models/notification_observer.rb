class NotificationObserver < ActiveRecord::Observer
  observe :user,:post, :rating, :course, :course_membership, :lecture_membership, :faculty_membership

  def deliver_email_notification(post, user)
    email_setting = EmailSetting.find_by_user_id(user.id)
    membership = CourseMembership.find_by_user_id_and_course_id(user.id, post.course.id) 

    # if new user who does not changed settings receives emails (opt-out)
    return true if email_setting.nil?

    # if user wants emails for this post thread when user is author of comment, answer or origin past
    return true if email_setting.notification_when_author and post.origin.all_authors.include? user
  
    # if user has subscribed to course and wants emails for this subscription
    return true if membership and email_setting.emails_for_subscribtions

    # otherwise
    return false
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
          notification = Notification.create!(:receiver => receiver, :sender => sender, :notifiable_id => post.id, :notifiable_type => post.class.name)
          
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
