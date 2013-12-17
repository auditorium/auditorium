# == Schema Information
#
# Table name: levels
#
#  id          :integer          not null, primary key
#  threshold   :integer
#  number      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :level do
    threshold 1
    number 1
  end
end
