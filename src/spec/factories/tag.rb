# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag, :class => 'Tag' do
    name "MyString"
    post nil
  end
end
