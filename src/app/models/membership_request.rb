class MembershipRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :user_id, :course_id, :membership_type
end
