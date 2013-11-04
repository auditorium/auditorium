# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  memberable_id   :integer
#  memberable_type :string(255)
#  role            :string(255)      default("member")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Membership < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :memberable, :polymorphic => true# thinks you can be member of

  validates :membership_type,  presence: true, inclusion: { in: %w{maintainer editor member} }
  validates :user,  presence: true
  validates :memberable, presence: true
end
