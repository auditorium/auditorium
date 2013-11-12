# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :text
#  rating     :integer          default(0)
#  views      :integer
#  is_private :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  author_id  :integer
#

class Topic < ActiveRecord::Base 
  include Votable
  include Taggable
  include ParentPost
  include Notifiable
  
  define_index do
    indexes subject
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).topic
  end

  def authors
    authors = Array.new
    authors << self.author
    authors += self.comments.map(&:author)
    authors.uniq
  end
end
