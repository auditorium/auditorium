module Notifiable

  def self.included(base)
    base.after_create :notify
  end

private
  def notify

    case self.class.name
    when 'Question','Announcement', 'Topic', 'Video'
      receivers = receivers_for_new_post_in(self.group)
      receivers.each do |receiver|
        AuditoriumMailer.new_parent_post(author: self.author, receiver: receiver, parent_post: self).deliver
      end
    when 'Comment'
      receivers = receivers_for_new_post_in(self.commentable.group)

      receivers.each do |receiver|
        AuditoriumMailer.new_comment(author: self.author, receiver: receiver, comment: self).deliver
      end
    when 'Answer'
      receivers = receivers_for_new_post_in(self.question.group)
      receivers.each do |receiver|
        AuditoriumMailer.new_answer(author: self.author, receiver: receiver, answer: self).deliver
      end
    when 'Group'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    else
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    end

  end

  def receivers_for_new_post_in(group)
    receivers = Array.new
    # follower: user object
    group.followers.each do |follower|
      unless self.author == follower 
        if follower.setting.present?
          if follower.setting.receive_email_notifications and follower.will_receive_email_notifications(group)
            receivers << follower 
          end
        else
          receivers << follower
        end
      end
    end

    # add authorship notifications for non members if setting
    if self.class.name.eql? 'Comment'
      authors = Array.new
      case self.commentable_type
      when 'Answer' 
        answer = Answer.find(self.commentable_id)
        authors = answer.question.authors
      when 'Question'
        question = Question.find(self.commentable_id)
        authors = question.authors
      when 'Announcement'
        announcement = Announcement.find(self.commentable_id)
        authors = announcement.authors
      when 'Topic'
        topic = Topic.find(self.commentable_id)
        authors = topic.authors
      when 'Video'
        video = Video.find(self.commentable_id)
        authors = video.authors
      end
      receivers += authors.keep_if { |a| a.setting.nil? or a.setting.receive_emails_when_author }
    end

    receivers.uniq
  end
end