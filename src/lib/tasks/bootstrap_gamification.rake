namespace :bootstrap do
  desc "Grant badges and points to users"
  task :gamification => :environment do
    application = ApplicationController.new

    User.all.each do |user|
      user.score = 0
      user.badges = []
      user.level = Level.find_by_number(0)

      puts "---- #{user} ----"
      # learning badge
      puts "-- LEARNING BADGE"
      application.achieve_learning_badge(user, 'bronze', 1)
      application.achieve_learning_badge(user, 'silver', 5)
      application.achieve_learning_badge(user, 'gold', 10)

      # commenter badge
      puts "-- COMMENTER BADGE"
      application.achieve_commenter_badge(user, 'bronze', 1)
      application.achieve_commenter_badge(user, 'silver', 5)
      application.achieve_commenter_badge(user, 'gold', 10)

      # significant badge
      puts "-- SIGNIFICANT BADGE"
      application.achieve_significant_badge(user, 'bronze', 1)
      application.achieve_significant_badge(user, 'silver', 5)
      application.achieve_significant_badge(user, 'gold', 10)
      
      # helpful
      puts "-- HELPFUL BADGE"
      application.achieve_cooperative_badge(user, 'bronze', 1)
      application.achieve_cooperative_badge(user, 'silver', 5)
      application.achieve_cooperative_badge(user, 'gold', 10)

      # cooperative
      puts "-- COOPERATIVE BADGE"
      application.achieve_cooperative_badge(user, 'bronze', 1)
      application.achieve_cooperative_badge(user, 'silver', 5)
      application.achieve_cooperative_badge(user, 'gold', 10)

      # helpful
      puts "-- HELPFUL BADGE"
      application.achieve_helpful_badge(user)

      # something to say
      puts "-- SOMETHING TO SAY BADGE"
      application.achieve_something_to_say_badge(user, 'bronze', 1)
      application.achieve_something_to_say_badge(user, 'silver', 5)
      application.achieve_something_to_say_badge(user, 'gold', 10)

      # critical
      puts "-- CRITICAL BADGE"
      application.achieve_critical_badge(user) if user.votings.where(value: -1).size > 0

      # rewarding
      puts "-- REWARDING BADGE"
      application.achieve_rewarding_badge(user) if user.votings.where(value: 1).size > 0

      # biographer
      puts "-- BIOGRAOHER BADGE"
      application.achieve_biographer_badge(user)

      # party badge
      puts "-- PARTY BADGE"
      application.achieve_party_badge(user) if user.groups.size > 0

      puts "-- CALCULATE VOTINGS"
      user.votings.each do |vote|
        if vote.value == -1
          user.score -= 1
        end
      end

      puts "-- CALCULATE SCORE"
      user.questions.each { |question| user.score += question.rating * 5 }
      user.answers.each { |answer| user.score += answer.rating * 5 }
      user.announcements.each { |announcement| user.score += announcement.rating * 5 }
      user.topics.each { |topic| user.score += topic.rating * 5 }
      user.comments.each { |comment| user.score += comment.rating * 5 }
      user.save
      puts "-- SCORE: #{user.score}"
      puts "-- LEVEL: #{user.level.inspect}"
      puts "-- BADGES: #{user.badges.map(&:to_s)}"
    end
  end

  desc "Divide users into experimental and control groups"
  task divide_users: :environment do 
    puts '"ACTIVITY INDEX", "# USERS"'
    User.all.group_by { |u| u.activity_index }.each do |index, users|
      puts "#{index}, #{users.size}" 
    end
  end
end