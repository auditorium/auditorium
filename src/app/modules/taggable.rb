module Taggable 

  def self.included(base)
    base.has_many :tags, through: :taggings
    base.has_many :taggings, as: :taggable

    base.attr_accessible :tag_tokens
    attr_reader :tag_tokens
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