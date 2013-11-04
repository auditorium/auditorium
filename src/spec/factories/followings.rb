# == Schema Information
#
# Table name: followings
#
#  id                    :integer          not null, primary key
#  follower_id           :integer
#  followerable_id       :integer
#  followerable_type     :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  role                  :string(255)      default("member")
#  receive_notifications :boolean          default(TRUE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :following do
    follower nil
    followerable nil
  end
end
