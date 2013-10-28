class Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true
  attr_accessible :value, :user_id, :votable_id, :votable_type
end
