class NotificationObserver < ActiveRecord::Observer
  observe :post, :rating, :course_membership, :lecture_membership, :faculty_membership
  
  def after_create(model)
    # code to send confirmation email...
    Rails.logger.debug "OBSERVE #{model}"
    
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
      
        if post.is_private?
          #send email notifications to moderators
          AuditoriumMailer.private_question(receiver, post).deliver
        end
      end
    end
  end
end
