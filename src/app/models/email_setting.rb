class EmailSetting < ActiveRecord::Base
  belongs_to :user
  attr_accessible :html_format, :emails_for_subscribtions, :weekly

	validates :user, :presence => true
end
