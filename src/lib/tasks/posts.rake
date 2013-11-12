
namespace :posts do
  desc "Update last activity when nil"
  task :update_last_activity => :environment do
    Question.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end

    Topic.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end

    Announcement.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end

    Video.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end

    Answer.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end

    Comment.all.each do |q|
      q.last_activity = DateTime.now
      q.save
      puts q.inspect
    end
  end
end