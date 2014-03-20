# == Schema Information
#
# Table name: institutes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  faculty_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url        :string(255)
#

class Institute < ActiveRecord::Base
  belongs_to :faculty
  has_many :chairs, :dependent => :destroy

  attr_accessible :name, :faculty_id

  validates :name, presence: true
  validates :faculty, presence: true

  def to_s 
    self.name
  end

  def parent
    self.faculty
  end

  def children
    self.chairs
  end

end
