# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    subject "MyString"
    content "MyString"
    rating 1
    views 1
    private false
  end
end
