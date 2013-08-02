FactoryGirl.define do
  factory :user do
    username { Faker::Lorem.word }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }

    factory :invalid_user do
      email nil
    end

    factory :admin do
      admin true
    end
  end
end