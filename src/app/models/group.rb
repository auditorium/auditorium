class Group < ActiveRecord::Base
  
  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  attr_accessible :description, :title, :tag_list

  def self.tagged_with(name)
  	Tag.find_by_name!(name).groups
  end

  def tag_list
  	self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
  	self.tags = names.split(",").map do |n|
  		Tag.where(name: n.strip).first_or_create!
  	end 
  end 
end
