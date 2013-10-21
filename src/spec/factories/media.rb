# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium, :class => 'Media' do
    content "MyText"
    subject "MyString"
    url "MyString"
    views 1
    private false
    author nil
    group nil
  end
end
