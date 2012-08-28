FactoryGirl.define do
  factory :user, aliases: [:tutor, :maintainer] do
    email { (0...6).map{65.+(rand(25)).chr}.join + "@example.com" }
    password "123456"
    password_confirmation "123456"
  end
end
