class TutorialProgress < ActiveRecord::Base
  belongs_to :tutorial_progress
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
end
