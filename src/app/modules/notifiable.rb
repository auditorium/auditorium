module Notifiable

  def self.included(base)
    base.after_create :notify
  end

private
  def notify
    #Rails.logger.info "NOTIFY: #{current_user.inspect} - #{self.class.name} - #{self.content}"

    case self.class.name
    when 'comment'
      # calculate who will receive the notification
      # every group subscriber
      # every author
      group = self.group

      
      receivers(group)

      AuditoriumMailer.new_comment(self).deliver
    when 'answer'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    when 'question'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    when 'announcement'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    when 'topic'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    when 'group'
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    else
      Rails.logger.info "NOTIFICATION: #{self.class.name}"
    end

  end

  def receivers(group)
    # follower: user object
    group.followers.each do |follower|
      if follower.setting.present?

      else
        receivers << follower
      end
    end
  end
end