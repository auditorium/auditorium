FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end
