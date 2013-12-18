class GamificationObserver < ActiveRecord::Observer
  observe :group, :question, :announcement, :topic, :comment, :answer, :voting

  def after_create(record)
    puts "=============== OBSERVING ==============="
    case record.class.name
    when 'Group'
      puts "GROUP"
    when 'Question'
      if record.author.questions.size >= 5
        record.author.badges << Badge.find_by_title('asker') 
      end
      puts " ============= QUESTION ============== "
    when 'Announcement'
      puts "ANNOUNCEMENT"
    when 'Topic'
      puts "TOPIC"
    when 'Comment'
      puts "COMMENT"
    when 'Answer'
      puts "ANSWER"
    when 'Voting'
      puts "VOTING"

    end
  end
end
