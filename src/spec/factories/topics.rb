# == Schema Information
#
# Table name: topics
#
#  id            :integer          not null, primary key
#  subject       :string(255)
#  content       :text
#  rating        :integer          default(0)
#  views         :integer
#  is_private    :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_id      :integer
#  author_id     :integer
#  last_activity :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    subject { Faker::Lorem.words.join(" ").titleize }
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end
