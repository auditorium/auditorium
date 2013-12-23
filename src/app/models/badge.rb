class Badge < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title, :score, :category

  validates :category, presence: true, inclusion: { in: %w{bronze silver gold platinium} }
  validates :score, presence: true
  validates :title, presence: true
  validates :description, presence: true
end