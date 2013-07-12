#encoding: utf-8 
namespace :stats do 
  desc "Generate data dump for users"
  task :users => :environment do 
    puts "Datum, Gesamt, Student, Mitarbeiter"
    User.where("confirmed_at is not null").each_with_index do |user, index|
      if user.email.match /@mailbox.tu-dresden.de|@mail.zih.tu-dresden.de/
        puts "#{user.created_at.strftime('%m/%Y')},1,1,0"
      else
        puts "#{user.created_at.strftime('%m/%Y')},1,0,1"
      end
    end
  end

  desc "Generate data dump for posts"
  task :posts => :environment do 
    puts "Datum, Gesamt,Frage, Antwort, Kommentar, Ankündigung, Vorlesungsvideo"
    Post.all.each do |post|
      if post.post_type.eql? 'question'
        puts "#{post.created_at.strftime('%m/%Y')},1,1,0,0,0,0"
      elsif post.post_type.eql? 'answer'
        puts "#{post.created_at.strftime('%m/%Y')},1,0,1,0,0,0"
      elsif post.post_type.eql? 'comment'
        puts "#{post.created_at.strftime('%m/%Y')},1,0,0,1,0,0"
      elsif post.post_type.eql? 'info'
        puts "#{post.created_at.strftime('%m/%Y')},1,0,0,0,1,0"
      elsif post.post_type.eql? 'recording'
        puts "#{post.created_at.strftime('%m/%Y')},1,0,0,0,0,1"
      end
    end
  end
end
