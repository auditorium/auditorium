# == Schema Information
#
# Table name: email_settings
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  daily                    :boolean          default(TRUE)
#  emails_for_subscribtions :boolean          default(TRUE)
#  weekly                   :boolean          default(TRUE)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  notification_when_author :boolean          default(TRUE)
#

class EmailSetting < ActiveRecord::Base
  belongs_to :user
  attr_accessible :daily, :weekly, :emails_for_subscribtions, :notification_when_author

	validates :user, :presence => true
end
