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

private
  def set_code
    self.code = Rack::Utils.parse_query(URI(self.url).query)['v']
  end
end
