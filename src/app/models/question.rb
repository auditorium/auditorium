class Question < ActiveRecord::Base 

  include Taggable
  include ParentPost
  include Notifiable

  has_many :answers, :dependent => :destroy

  def self.tagged_with(name)
    Tag.find_by_name!(name).question
  end
end
