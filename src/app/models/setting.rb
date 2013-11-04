# == Schema Information
#
# Table name: settings
#
#  id                          :integer          not null, primary key
#  receive_emails_when_author  :boolean          default(TRUE)
#  receive_email_notifications :boolean          default(TRUE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  user_id                     :integer
#

class Setting < ActiveRecord::Base
  belongs_to :user
  # attr_accessible :title, :body
  attr_accessible :receive_email_notifications, :receive_emails_when_author, :user_id

  validates_uniqueness_of :user_id, message: I18n.t('users.profile.settings.uniqueness_error')
end
