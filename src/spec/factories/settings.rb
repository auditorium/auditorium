# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    receive_email false
    user nil
  end
end
