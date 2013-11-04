# == Schema Information
#
# Table name: course_memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  course_id       :integer
#  membership_type :string(255)      default("member")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifyable_id   :integer
#  notifyable_type :string(255)
#  receive_emails  :boolean          default(TRUE)
#

class CourseMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :membership_type, :user_id, :course_id

  validates :membership_type,  presence: true,
                    inclusion: { in: %w{maintainer editor member} }
  validates :user,  presence: true
  validates :course,  presence: true
end
