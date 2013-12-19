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

class TutorialProgress < ActiveRecord::Base
  belongs_to :user
  attr_accessible :group, :groups, :introduction, :question

  def progress
    max = 4
    value = 0
    value += 1 if self.group?
    value += 1 if self.groups?
    value += 1 if self.introduction?
    value += 1 if self.question

    value
  end

  def max_value
    4
  end

  def percentage
    self.progress * 100.0 / self.max_value 
  end
end
