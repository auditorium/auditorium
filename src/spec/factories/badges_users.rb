# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :badges_user, :class => 'BadgesUsers' do
    user nil
    badge nil
  end
end
