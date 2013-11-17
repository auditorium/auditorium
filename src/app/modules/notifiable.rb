module Notifiable

  def self.included(base)
    base.after_create :send_notification
  end   

private
  def send_notification
    case self.class.name
    when 'Comment'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_comment(author: self.author, receiver: receiver, comment: self).deliver if deliver_email_notification(self, receiver)
      end
    when 'Question'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_question(author: self.author, receiver: receiver, question: self).deliver if deliver_email_notification(self, receiver)
      end
    
    when 'Announcement'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_announcement(author: self.author, receiver: receiver, announcement: self).deliver if deliver_email_notification(self, receiver)
      end

    when 'Topic'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_topic(author: self.author, receiver: receiver, topic: self).deliver if deliver_email_notification(self, receiver)
      end
    when 'Video'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_video(author: self.author, receiver: receiver, video: self).deliver if deliver_email_notification(self, receiver)
      end

    when 'Answer'
      receivers = receivers_for_posts
      receivers.each do |receiver|
        Notification.create!(sender: self.author, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_answer(author: self.author, receiver: receiver, answer: self).deliver if deliver_email_notification(self, receiver)
      end
    when 'Group'
      unless self.creator.admin?
        receivers = User.where(admin: true)
        receivers.each do |receiver|
          Notification.create!(sender: self.creator, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
          AuditoriumMailer.group_to_approve(creator: self.creator, receiver: receiver, group: self).deliver
        end
      end
    when 'MembershipRequest'
      receivers = Array.new
      receivers << self.group.creator
      receivers += self.group.moderators

      receivers.uniq.each do |receiver|
        Notification.create!(sender: self.user, receiver: receiver, notifiable_id: self.id, notifiable_type: self.class.name)
        AuditoriumMailer.new_membership_request(user: self.user, receiver: receiver, membership_request: self).deliver
      end

    when 'MembershipRequest'
      # membership requests
    end 
  end

  def receivers_for_posts
    #self.origin.last_activity = DateTime.now
    #self.origin.save!
    if self.origin.is_private?
      receivers = self.origin.group.moderators
      receivers << self.origin.author
      receivers = receivers.uniq
    else
      receivers = self.origin.group.followers
      receivers += self.origin.authors
      receivers = receivers.uniq
    end

    receivers.delete_if {|receiver| receiver.id == self.author_id}
  end

  def deliver_email_notification(post, user)
    setting = user.setting
    following = post.origin.group.followings.find_by_follower_id(user.id)

    # if new user who does not changed settings receives emails (opt-out)
    return true if setting.nil?

    

    # if user wants emails for this post thread when user is author of comment, answer or origin post
    return true if setting.receive_emails_when_author and post.origin.authors.include? user
    
    # if user has subscribed to course and wants emails for this subscription
    return true if following.present? and following.receive_notifications?
    
    # otherwise
    return false
  end
end