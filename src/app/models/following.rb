class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followerable, polymorphic: true

  attr_accessible :follower_id

  validates :role,  presence: true, inclusion: { in: %w{moderator member} }
end
