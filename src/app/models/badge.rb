# == Schema Information
#
# Table name: badges
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Badge < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title
end
