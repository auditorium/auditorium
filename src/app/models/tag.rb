class Tag < ActiveRecord::Base
	
  has_many :taggings
  with_options through: :taggings, source: :taggable do |tag|
  	tag.has_many :groups, source_type: 'Group'
  end

  attr_accessible :name, :description

  validates :name,  presence: true
  # validates :description, presence: true

  def self.tokens(query)
    tags = where("name LIKE ?", "%#{query}%")
    if tags.empty?
      [{ id: "<<<#{query}>>>", name: I18n.translate('tags.new_entry', name: query)}]
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
