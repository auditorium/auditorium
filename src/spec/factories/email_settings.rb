# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_setting do
    user nil
    plain_text_emails false
    emails_for_subscribtions false
  end
end
