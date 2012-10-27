class EmailSetting < ActiveRecord::Base
  belongs_to :user
  attr_accessible :daily, :weekly, :emails_for_subscribtions, :notification_when_author

	validates :user, :presence => true
end
