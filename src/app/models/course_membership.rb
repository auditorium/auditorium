class CourseMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :membership_type, :user_id, :course_id

  validates :membership_type,  presence: true,
                    inclusion: { in: %w{maintainer editor member} }
  validates :user,  presence: true
  validates :course,  presence: true
end
