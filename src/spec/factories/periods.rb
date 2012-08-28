# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :period do
    weekday "monday"
    minute_of_day (9*60 + 20)
    duration 90
    event
  end
end
