class TutorialProgress < ActiveRecord::Base
  belongs_to :tutorial_progress
  attr_accessible :group, :groups, :introduction, :question
end
