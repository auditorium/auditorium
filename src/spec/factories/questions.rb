FactoryGirl.define do
  factory :question do
    subject { Faker::Lorem.words.join(" ").titleize }
    description { Faker::Lorem.sentences.join(" ") }
    author { }
  end
end