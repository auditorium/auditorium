class NotificationObserver < ActiveRecord::Observer
  observe :post, :rating, :course_membership, :lecture_membership, :faculty_membership

  def send_course_updates_to?(receiver)
    email_setting = EmailSetting.find_by_user_id(receiver.id)
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
      if post.is_private?
        receivers = post.course.moderators
      else
        receivers = post.course.users
        receivers << post.origin.author if not receivers.include? post.origin.author 
      end

      receivers.delete_if {|receiver| receiver.id == post.author_id}
      sender = post.author
      
      receivers.each do |receiver|
        Notification.create!(:receiver => receiver, :sender => sender, :notifyable_id => post.id, :notifyable_type => post.class.name)
        
        # send emails to subscribers
        AuditoriumMailer.update_in_course(receiver, post).deliver if send_course_updates_to?(receiver)

        puts "RECEIVE? #{send_course_updates_to?(receiver)}"
        AuditoriumMailer.private_question(receiver, post).deliver if post.is_private?

      end
    end
  end
end
