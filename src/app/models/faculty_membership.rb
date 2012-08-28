class FacultyMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :faculty
  attr_accessible :membership_type

  validates :faculty_id,  :presence => true
  validates :user_id,     :presence => true
end
