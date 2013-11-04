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

require 'spec_helper'

describe Setting do
  pending "add some examples to (or delete) #{__FILE__}"
end
