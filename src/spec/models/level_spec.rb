# == Schema Information
#
# Table name: levels
#
#  id          :integer          not null, primary key
#  threshold   :integer
#  number      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

require 'spec_helper'

describe Level do
  pending "add some examples to (or delete) #{__FILE__}"
end
