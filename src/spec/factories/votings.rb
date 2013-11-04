# == Schema Information
#
# Table name: votings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  value        :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voting do
    user nil
    value 1
  end
end
