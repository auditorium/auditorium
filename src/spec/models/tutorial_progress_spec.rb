# == Schema Information
#
# Table name: tutorial_progresses
#
#  id           :integer          not null, primary key
#  introduction :boolean          default(FALSE)
#  groups       :boolean          default(FALSE)
#  group        :boolean          default(FALSE)
#  question     :boolean          default(FALSE)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe TutorialProgress do
  pending "add some examples to (or delete) #{__FILE__}"
end
