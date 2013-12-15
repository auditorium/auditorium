class GamificationObserver < ActiveRecord::Observer
  observe :group, :question, :announcement, :topic, :comment, :answer, :voting

  def after_save(record)
    case record
    when Group
      puts "GROUP"
    when Question
      puts "QUESTION"
    when Announcement
      puts "ANNOUNCEMENT"
    when Topic
      puts "TOPIC"
    when Comment
      puts "COMMENT"
    when Answer
      puts "ANSWER"
    when Voting
      puts "VOTING"

    end
  end
end
