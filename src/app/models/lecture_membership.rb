# == Schema Information
#
# Table name: lecture_memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  lecture_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :integer
#  notifiable_type :string(255)
#

class LectureMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :lecture
end
