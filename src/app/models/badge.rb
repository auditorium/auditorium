class Badge < ActiveRecord::Base
  has_and_belongs_to_many :users

  attr_accessible :description, :title, :score, :category

  validates :category, presence: true, inclusion: { in: %w{bronze silver gold platinium} }
  validates :score, presence: true
  validates :title, presence: true
  validates :description, presence: true

  def to_s
    "#{self.title} (#{category})"
  end
end