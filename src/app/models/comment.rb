class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'
  
  attr_accessible :author_id, :content, :rating

  validates :commentable, presence: true
  validates :content, presence: true
  validates :author, presence: true
end
