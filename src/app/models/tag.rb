# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class Tag < ActiveRecord::Base
	
  has_many :taggings
  
  with_options through: :taggings, source: :taggable do |tag|
  	tag.has_many :groups, source_type: 'Group'
  end

  attr_accessible :name, :description

  validates :name,  presence: true
  validates_uniqueness_of :name
  # validates :description, presence: true

  def self.tokens(options = {})
    tags = where("name LIKE ?", "%#{options[:query]}%")
    if tags.empty? and !options[:filter]
      [{ id: "<<<#{options[:query]}>>>", name: I18n.translate('tags.new_entry', name: options[:query])}]
    else
      tags
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
