# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  content    :text
#  subject    :string(255)
#  url        :string(255)
#  views      :integer
#  is_private :boolean
#  author_id  :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string(255)
#  rating     :integer          default(0)
#

class Video < ActiveRecord::Base
  before_save :set_code
  
  include Votable
  include Taggable
  include ParentPost

  attr_accessible :private, :url
  validates :url, presence: true

  define_index do
    indexes subject
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).video
  end

  def authors
    authors = Array.new
    authors << self.author
    authors += self.comments.map(&:author)
    authors.uniq
  end

private
  def set_code
    self.code = Rack::Utils.parse_query(URI(self.url).query)['v']
  end
end
