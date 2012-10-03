class Feedback < ActiveRecord::Base
  attr_accessible :content, :read
  validates :content, presence: true
end
