# == Schema Information
#
# Table name: settings
#
#  id                          :integer          not null, primary key
#  receive_emails_when_author  :boolean          default(TRUE)
#  receive_email_notifications :boolean          default(TRUE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  user_id                     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    receive_email_notifications true
    receive_emails_when_author true
  end
end
