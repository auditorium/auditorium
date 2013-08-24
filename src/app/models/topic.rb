class Topic < ActiveRecord::Base 
  belongs_to :group
  belongs_to :author, class_name: 'User'

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  validates :subject, presence: true
  validates :group, presence: true
  validates :content, presence: true
  validates :author, presence: true

  attr_accessible :subject, :content, :group, :tag_tokens
  attr_reader :tag_tokens

  define_index do
    indexes subject
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).question
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
