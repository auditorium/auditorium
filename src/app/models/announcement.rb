class Announcement < ActiveRecord::Base 

  include Taggable
  include ParentPost

  define_index do
    indexes subject
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).question
  end
end
