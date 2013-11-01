module Notifiable

  def self.included(base)
    base.after_create :notify
  end

private
  def notify
    #Rails.logger.info "NOTIFY: #{current_user.inspect} - #{self.class.name} - #{self.content}"
    if self.class.name.eql? 'Comment'
      AuditoriumMailer.new_comment(self).deliver
    end
  end
end