class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followerable, polymorphic: true

  validates :role,  presence: true, inclusion: { in: %w{moderator member} }
end
