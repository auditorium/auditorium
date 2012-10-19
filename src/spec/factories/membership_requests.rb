# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership_request do
    user nil
    course ""
    membership_type "MyString"
    approved false
  end
end
