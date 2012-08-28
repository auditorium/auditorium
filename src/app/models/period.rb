class Period < ActiveRecord::Base
  belongs_to :event
  attr_accessible :duration, :place, :weekday, :minute_of_day, :event_id

  validates :weekday, presence: true,
                      inclusion: { in: %w{monday tuesday wednesday thursday friday saturday sunday} }
  validates :minute_of_day,   presence: true,
                              inclusion: { in: (0..60*24) }, # changed because [0, 60*24] contained only 2 elements... raised errors
                              numericality: true
  validates :duration,  presence: true,
                        numericality: true
  validates :event, presence: true
end
