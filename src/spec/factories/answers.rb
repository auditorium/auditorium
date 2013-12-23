# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  content       :text
#  rating        :integer          default(0)
#  question_id   :integer
#  author_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  answer_to_id  :integer
#  last_activity :datetime
#

FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end
