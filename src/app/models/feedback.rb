# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  read       :boolean          default(FALSE)
#

class Feedback < ActiveRecord::Base
  attr_accessible :content, :read
  validates :content, presence: true
end
