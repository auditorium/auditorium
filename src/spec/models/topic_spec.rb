# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :text
#  rating     :integer          default(0)
#  views      :integer
#  is_private :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  author_id  :integer
#

require 'spec_helper'

describe Topic do
  pending "add some examples to (or delete) #{__FILE__}"
end
