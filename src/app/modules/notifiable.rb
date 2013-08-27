module Notifiable

  def self.included(base)
    base.after_create :notify
  end

private
  def notify
    Rails.logger.info "#{self.class.name} - #{self.content}"
    100.times do
      AuditoriumMailer.delay.new_comment(self)
    end
  end
end