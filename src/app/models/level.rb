# == Schema Information
#
# Table name: levels
#
#  id          :integer          not null, primary key
#  threshold   :integer
#  number      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class Level < ActiveRecord::Base
  
  has_many :users
  attr_accessible :number, :threshold, :description
end
