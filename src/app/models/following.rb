# == Schema Information
#
# Table name: followings
#
#  id                    :integer          not null, primary key
#  follower_id           :integer
#  followerable_id       :integer
#  followerable_type     :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  role                  :string(255)      default("member")
#  receive_notifications :boolean          default(TRUE)
#

class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followerable, polymorphic: true

  attr_accessible :follower_id

  validates :role,  presence: true, inclusion: { in: %w{moderator member} }
end
