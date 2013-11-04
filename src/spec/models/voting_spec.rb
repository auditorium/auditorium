# == Schema Information
#
# Table name: votings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  value        :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Voting do
  pending "add some examples to (or delete) #{__FILE__}"
end
