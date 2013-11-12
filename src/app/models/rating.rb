# == Schema Information
#
# Table name: ratings
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  post_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  points          :integer          default(0)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#

class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  attr_accessible :points, :user_id, :post_id

  validates :user, :presence => true
  validates :post, :presence => true
  # attr_accessible :title, :body
end
