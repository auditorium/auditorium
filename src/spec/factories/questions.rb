# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :text
#  rating     :integer          default(0)
#  views      :integer
#  is_private :boolean
#  author_id  :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :question do
    topic_group
    subject { Faker::Lorem.words.join(" ").titleize }
    description { Faker::Lorem.sentences.join(" ") }
  end
end
