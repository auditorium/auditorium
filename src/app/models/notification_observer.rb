class NotificationObserver < ActiveRecord::Observer
  observe :user,:post, :rating, :course, :course_membership, :lecture_membership, :faculty_membership


  def send_course_updates_to?(receiver, course)
    email_setting = EmailSetting.find_by_user_id(receiver.id)
    
    if course.moderators.include? receiver
      return true
    end

    if email_setting.nil?
      return true

    else
      email_setting.emails_for_subscribtions
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
          receivers << post.origin.author if !post.course.moderators.include? post.origin.author
        else
          receivers = post.course.users
          receivers << post.origin.author if not receivers.include? post.origin.author 
        end

        receivers.delete_if {|receiver| receiver.id == post.author_id}
        sender = post.author
        
        receivers.each do |receiver|
          notification = Notification.create!(:receiver => receiver, :sender => sender, :notifyable_id => post.id, :notifyable_type => post.class.name)
          
          # send emails to subscribers
          AuditoriumMailer.update_in_course(receiver, post).deliver if send_course_updates_to?(receiver, post.course) 
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
