# == Schema Information
#
# Table name: votings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  value        :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true
  attr_accessible :value, :user_id, :votable_id, :votable_type
end
