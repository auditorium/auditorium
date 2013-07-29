class Group < ActiveRecord::Base
  
  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable
  has_many :questions

  belongs_to :creator, class_name: 'User'

  attr_accessible :description, :title, :group_type, :tag_tokens, :creator_id
  attr_reader :tag_tokens

  validates :title, presence: true
  validates :description, presence: true
  validates :group_type, presence: true, inclusion: { in: %w{lecture topic learning} }
  
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

  def tag_tokens=(tokens)  
    self.tag_ids = Tag.ids_from_tokens(tokens)  
  end  
end
