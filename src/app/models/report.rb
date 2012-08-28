class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reporter, :class_name => 'User'
  belongs_to :post

  attr_accessible :post_id, :reporter_id, :body


  validate :body,       :presence => true
  validate :post,       :presence => true
end
