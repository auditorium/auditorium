FactoryGirl.define do
  factory :announcement do
    subject { Faker::Lorem.words.join(" ").titleize }
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end