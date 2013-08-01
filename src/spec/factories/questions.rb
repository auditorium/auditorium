FactoryGirl.define do
  factory :question do
    topic_group
    subject { Faker::Lorem.words.join(" ").titleize }
    description { Faker::Lorem.sentences.join(" ") }
  end
end