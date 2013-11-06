# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  first_name             :string(255)
#  last_name              :string(255)
#  title                  :string(255)      default("")
#  website                :string(255)
#  alternative_email      :string(255)
#  score                  :integer          default(0)
#  authentication_token   :string(255)
#  role                   :string(255)
#

FactoryGirl.define do
  factory :user do
    username { Faker::Lorem.word }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }

    factory :invalid_user do
      email nil
    end

    factory :admin do
      admin true
    end

    factory :user_will_receive_email_notifications do 
      after(:create) do |user|
        user.setting = create(:setting)
      end
    end

    factory :user_will_not_receive_email_notifications do 
      after(:create) do |user|
        user.setting = create(:setting, receive_email_notifications: false)
      end
      
    end

    factory :user_will_not_receive_email_notifications_when_author do 
      after(:create) do |user|
        user.setting = create(:setting, receive_emails_when_author: false)
      end
    end
  end
end
