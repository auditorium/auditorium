# == Schema Information
#
# Table name: followings
#
#  id                    :integer          not null, primary key
#  follower_id           :integer
#  followerable_id       :integer
#  followerable_type     :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  role                  :string(255)      default("member")
#  receive_notifications :boolean          default(TRUE)
#

require 'spec_helper'

describe Following do
  pending "add some examples to (or delete) #{__FILE__}"
end
