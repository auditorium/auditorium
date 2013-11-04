module Notifiable

  def self.included(base)
    base.after_create :notify
  end

private
  def notify
    #Rails.logger.info "NOTIFY: #{current_user.inspect} - #{self.class.name} - #{self.content}"
    # case self.class.name
    # when 'comment':
    #   # calculate who will receive the notification
    #   # every group subscriber
    #   # every author
    #   group = self.group

    #   # follower: user object
    #   group.followers.each do |follower|
    #     # todo
    #   end

    #   AuditoriumMailer.new_comment(self).deliver
    # when 'answer':
    # when 'question':
    # when 'announcement':
    # when 'topic':
    # when 'group':

    # end
  end
end