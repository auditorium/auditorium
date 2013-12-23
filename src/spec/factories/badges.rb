# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :badge do
    category "MyString"
    score 1
    title "MyString"
    description "MyText"
  end
end
