class NotificationObserver < ActiveRecord::Observer
  observe :post, :rating, :course_membership, :lecture_membership, :faculty_membership
  
  def after_create(model)
    # code to send confirmation email...
    Rails.logger.debug "OBSERVE #{model}"
    
    if model.class.name.eql? 'Post'

      # if model.is_private?
      #   receivers = model.course.moderators
      # else
      #   receivers = model.course.users
      # end

      # receivers.delete_if {|user| user.id == model.author.id }
      # sender = model.author
      
      # receivers.each do |receiver|
      #   Notification.create!(:receiver => receiver, :sender => sender, :notifyable_id => model.id, :notifyable_type => model.class.name)
      # end
    end
  end

#todo
  def send_email(moderator)

    
  end
end
