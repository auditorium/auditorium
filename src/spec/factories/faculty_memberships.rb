# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faculty_membership do
    user nil
    faculty nil
    membership_type "MyString"
  end
end
