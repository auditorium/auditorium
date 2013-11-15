# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type    :string(255)
#  creator_id    :integer          default(1)
#  private_posts :boolean
#  url           :string(255)
#

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

    factory :study_group do
      group_type 'study'
    end

    factory :topic_group do
      group_type 'topic'
    end

    factory :invalid_group do
      group_type nil
    end

    factory :group_with_three_followers do
      group_type { ['topic', 'study', 'lecture'].sample }
      after(:create) do |group|
        f = Array.new
        (1..3).each do |i|
          group.followers << create(:user)
          #puts group.followers.inspect
        end
      end
    end
  end
end
