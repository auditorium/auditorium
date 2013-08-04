FactoryGirl.define do
  factory :group do
    title { Faker::Lorem.words.join(" ").titleize }
    description { Faker::Lorem.sentences.join(" ") }

    after(:build) do |group|
      group.creator = create(:user)
    end

    factory :lecture_group do
      group_type 'lecture'
    end

    factory :learning_group do
      group_type 'learning'
    end

    factory :topic_group do
      group_type 'topic'
    end

    factory :invalid_group do
      group_type nil
    end
  end
end