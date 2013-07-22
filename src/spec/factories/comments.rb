# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    author_id 1
    content "MyText"
    rating 1
    commentable nil
  end
end
