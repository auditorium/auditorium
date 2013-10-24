class Video < ActiveRecord::Base

  include Taggable
  include ParentPost

  attr_accessible :private, :url

  define_index do
    indexes subject
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).video
  end
 
end
