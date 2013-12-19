class GamificationObserver < ActiveRecord::Observer
  observe :group, :question, :announcement, :topic, :comment, :answer, :voting, :tutorial_progress, :user

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
    when 'TutorialProgress'
      # introduction :boolean          default(FALSE)
      #  groups       :boolean          default(FALSE)
      #  group        :boolean          default(FALSE)
      #  question     :boolean          default(FALSE)
      record.user.badges << Badge.find_by_title('curious') if record.introduction? and record.group? and record.groups? and record.question?
    end
  end

  def after_save(record)
    puts "=============== OBSERVING: #{record.class.name} ==============="
    case record.class.name
    when 'TutorialProgress'
      # introduction :boolean          default(FALSE)
      #  groups       :boolean          default(FALSE)
      #  group        :boolean          default(FALSE)
      #  question     :boolean          default(FALSE)
      if record.introduction? and record.group? and record.groups? and record.question?
        record.user.badges << Badge.find_by_title('curious') 
      end
    when 'Question'
      if !record.author.badges.map(&:title).include? 'learning' and record.rating >= 1     
        puts "========== LEARNING BADGE ============"
        record.author.badges << Badge.find_by_title('learning')
      elsif record.author.badges.map(&:title).include? 'learning' and record.rating < 1
        record.author.badges.delete(Badge.find_by_title('learning'))
      end
    when 'User'
      if record.profile_progress_percentage == 100
        puts "========== BIOGRAPHER BADGE ============"
        record.badges << Badge.find_by_title('biographer')
      else
        record.badges.delete(Badge.find_by_title('biographer'))
      end
    end
  end
end
