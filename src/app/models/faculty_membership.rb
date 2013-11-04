# == Schema Information
#
# Table name: faculty_memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  faculty_id      :integer
#  membership_type :string(255)      default("student")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifyable_id   :integer
#  notifyable_type :string(255)
#

class FacultyMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :faculty
  attr_accessible :membership_type

  validates :faculty_id,  :presence => true
  validates :user_id,     :presence => true
end
