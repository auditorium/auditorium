# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  reporter_id :integer
#  body        :text
#  read        :boolean          default(FALSE)
#  post_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reporter, :class_name => 'User'
  belongs_to :post

  attr_accessible :post_id, :reporter_id, :body


  validate :body,       :presence => true
  validate :post,       :presence => true
end
