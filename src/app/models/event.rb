# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_type :string(255)
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tutor_id   :integer
#  weekday    :integer
#  beginDate  :date
#  endDate    :date
#  week       :integer
#  url        :string(255)      default("")
#  building   :string(255)      default("")
#  room       :string(255)      default("")
#

class Event < ActiveRecord::Base
  has_many :periods # raum und zeit

  belongs_to :course
  belongs_to :tutor, class_name: 'User'

  attr_accessible :course_id, :tutor_id, :event_type # lecture, exercise, seminar, lab
  attr_accessible :weekday, :beginDate, :endDate, :week, :url, :building, :room
  
  
  validates :event_type,  presence: true,
                    inclusion: { in: %w{lecture exercise seminar lab} }
  validates :course,  presence: true
  validates :tutor, presence: true
end
