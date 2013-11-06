FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end