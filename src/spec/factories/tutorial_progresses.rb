# == Schema Information
#
# Table name: tutorial_progresses
#
#  id           :integer          not null, primary key
#  introduction :boolean          default(FALSE)
#  groups       :boolean          default(FALSE)
#  group        :boolean          default(FALSE)
#  question     :boolean          default(FALSE)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutorial_progress do
    introduction false
    groups false
    group false
    question false
  end
end
