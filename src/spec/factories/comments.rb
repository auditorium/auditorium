# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  author_id        :integer
#  content          :text
#  rating           :integer          default(0)
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_activity    :datetime
#

FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentences.join(" ") }
    author { create(:user) }
  end
end
