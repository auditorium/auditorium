# == Schema Information
#
# Table name: announcements
#
#  id            :integer          not null, primary key
#  subject       :string(255)
#  content       :text
#  rating        :integer          default(0)
#  views         :integer
#  is_private    :boolean
#  author_id     :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  last_activity :datetime
#

FactoryGirl.define do
  factory :announcement do
    subject { Faker::Lorem.words.join(" ").titleize }
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end
