class Setting < ActiveRecord::Base
  belongs_to :user
  # attr_accessible :title, :body
  attr_accessible :receive_email_notifications, :receive_emails_when_author, :user_id

  validates_uniqueness_of :user_id, message: I18n.t('users.profile.settings.uniqueness_error')
end
