class Tag < ActiveRecord::Base
	
  has_many :taggings
  with_options through: :taggings, source: :taggable do |tag|
  	tag.has_many :groups, source_type: 'Group'
  end

  attr_accessible :name, :description

  validates :name,  presence: true
  # validates :description, presence: true
end
