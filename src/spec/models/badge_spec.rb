# == Schema Information
#
# Table name: badges
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Badge do
  pending "add some examples to (or delete) #{__FILE__}"
end
