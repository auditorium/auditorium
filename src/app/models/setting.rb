class Setting < ActiveRecord::Base
  belongs_to :user
  attr_accessible :receive_email
end
