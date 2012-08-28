class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  attr_accessible :points, :user_id, :post_id

  validates :user, :presence => true
  validates :post, :presence => true
  # attr_accessible :title, :body
end
