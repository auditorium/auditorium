namespace :evaluation do
  desc "Anonymize users"
  task :monthly => :environment do

    puts "----- Questions ----"
    Question.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end

    puts "----- Answers ----"
    Answer.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end

    puts "----- Comments ----"
    Comment.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end

    puts "----- Announcements ----"
    Announcement.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end

    puts "----- Topics ----"
    Topic.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end

    puts "----- Recordings ----"
    Recording.all.group_by { |p| p.created_at.beginning_of_month }.each do |date, posts|
      puts "#{date.strftime('%m/%Y')}, #{posts.size}"
    end
  end

  desc "December to February activity by post type"
  task :before_december_to_february => :environment do
    puts "BEFORE"
    puts "Day, Questions, Answers, Comments, Announcements, Topics, Videos"
    (Date.new(2013, 12, 01)..Date.new(2013, 12, 26)).each do |day|
      questions = Question.where('created_at >= ? and created_at < ?',day, day.tomorrow).size
      answers = Answer.where('created_at >= ? and created_at < ?',day, day.tomorrow).size
      comments = Comment.where('created_at >= ? and created_at < ?',day, day.tomorrow).size
      announcements = Announcement.where('created_at >= ? and created_at < ?',day, day.tomorrow).size
      topics = Topic.where('created_at >= ? and created_at < ?',day, day.tomorrow).size
      videos = Video.where('created_at >= ? and created_at < ?',day, day.tomorrow).size

      overall = questions + answers + comments + announcements + topics + videos

      puts "#{I18n.l(day)}, #{questions}, #{answers}, #{comments}, #{announcements}, #{topics}, #{videos}, #{overall}"
    end
  end

  desc "December to February activity by post type"
  task :experimental_december_to_february => :environment do
    puts "EXPERIMENTAL GROUP"
    puts "Day, Questions, Answers, Comments, Announcements, Topics, Videos, Votings, Experimental Group"
    (Date.new(2013, 12, 27)..Date.new(2014, 02, 02)).each do |day|
      questions = Question.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      answers = Answer.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      comments = Comment.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      announcements = Announcement.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      topics = Topic.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      videos = Video.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and q.author.experimental_group? }.size
      votings = Voting.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.user.present? and q.user.experimental_group? }.size
      overall = questions + answers + comments + announcements + topics + videos + votings
      
      puts "#{I18n.l(day)}, #{questions}, #{answers}, #{comments}, #{announcements}, #{topics}, #{videos}, #{votings}, #{overall}"
    end
  end

  task :control_december_to_february => :environment do
    puts "CONTROL GROUP"
    puts "Day, Questions, Answers, Comments, Announcements, Topics, Videos, Votings, Control Group"
    (Date.new(2013, 12, 27)..Date.new(2014, 02, 02)).each do |day|
      questions =Question.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size
      answers =Answer.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size
      comments =Comment.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size
      announcements =Announcement.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size
      topics =Topic.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size
      videos =Video.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.author.present? and !q.author.experimental_group? }.size

      votings = Voting.where('created_at >= ? and created_at < ?',day, day.tomorrow).keep_if{ |q| q.user.present? and !q.user.experimental_group? }.size

      overall = questions + answers + comments + announcements + topics + videos + votings

      puts "#{I18n.l(day)}, #{questions}, #{answers}, #{comments}, #{announcements}, #{topics}, #{videos}, #{votings}, #{overall}"
    end
  end

  task :badges => :environment do
    puts "Badge, Category, Experimental Group, Control Group, Overall"
    Badge.all.each do |badge|
      control_group = badge.users.where(experimental_group: false).size
      experimental_group = badge.users.where(experimental_group: true).size
      overall = control_group + experimental_group

      puts "#{I18n.t("badges.titles.achieve_#{badge.title}.#{badge.category}", locale: 'en')}, #{badge.category}, #{experimental_group}, #{control_group}, #{overall}"
    end
  end

  task :levels => :environment do
    puts "Level, Experimental Group, Control Group, Overall"
    Level.all.each do |level|
      control_group = level.users.where(experimental_group: false).size
      experimental_group = level.users.where(experimental_group: true).size
      overall = control_group + experimental_group

      puts "#{level.number}, #{experimental_group}, #{control_group}, #{overall}"
    end
  end

  task :progress => :environment do
    puts "Progress, Experimental Group, Control Group, Overall"
    control_group = User.where(experimental_group: false).keep_if{ |u| u.profile_progress_percentage == 0 }.size
    experimental_group = User.where(experimental_group: true).keep_if{ |u| u.profile_progress_percentage == 0 }.size
    overall = control_group + experimental_group
    puts "0, #{experimental_group}, #{control_group}, #{overall}"

    control_group = User.where(experimental_group: false).keep_if{ |u| u.profile_progress_percentage == 25 }.size
    experimental_group = User.where(experimental_group: true).keep_if{ |u| u.profile_progress_percentage == 25 }.size
    overall = control_group + experimental_group
    puts "25, #{experimental_group}, #{control_group}, #{overall}"

    control_group = User.where(experimental_group: false).keep_if{ |u| u.profile_progress_percentage == 50 }.size
    experimental_group = User.where(experimental_group: true).keep_if{ |u| u.profile_progress_percentage == 50 }.size
    overall = control_group + experimental_group
    puts "50, #{experimental_group}, #{control_group}, #{overall}"


    control_group = User.where(experimental_group: false).keep_if{ |u| u.profile_progress_percentage == 75 }.size
    experimental_group = User.where(experimental_group: true).keep_if{ |u| u.profile_progress_percentage == 75 }.size
    overall = control_group + experimental_group
    puts "75, #{experimental_group}, #{control_group}, #{overall}"

    control_group = User.where(experimental_group: false).keep_if{ |u| u.profile_progress_percentage == 100 }.size
    experimental_group = User.where(experimental_group: true).keep_if{ |u| u.profile_progress_percentage == 100 }.size
    overall = control_group + experimental_group

    puts "100, #{experimental_group}, #{control_group}, #{overall}"    
  end

  task :tutorial_progress => :environment do
    puts "Introduction, Groups, Group, Question"

    introduction = User.where(experimental_group: true).keep_if{ |u| u.tutorial_progress.present? and u.tutorial_progress.introduction? }.size
    group = User.where(experimental_group: true).keep_if{ |u| u.tutorial_progress.present? and u.tutorial_progress.group? }.size
    groups = User.where(experimental_group: true).keep_if{ |u| u.tutorial_progress.present? and u.tutorial_progress.groups? }.size
    question = User.where(experimental_group: true).keep_if{ |u| u.tutorial_progress.present? and u.tutorial_progress.question? }.size

    puts "#{introduction}, #{groups}, #{group}, #{question}"
  end
end