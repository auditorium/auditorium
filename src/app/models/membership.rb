class Membership < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :memberable, :polymorphic => true# thinks you can be member of

  validates :membership_type,  presence: true, inclusion: { in: %w{maintainer editor member} }
  validates :user,  presence: true
  validates :memberable, presence: true
end
