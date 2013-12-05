# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first) 
# x = [1,2,3,4,5]

def self.add_random_tags 
  a = (0..Tag.all.size).to_a
  a.select {|_| rand(2).zero? }
  Tag.where(id: a)
end

x = (1..5).to_a

admin = User.where(email: 'admin@tu-dresden.de').first_or_initialize(username: 'admin', password: 'test1234', password_confirmation: 'test1234')
admin.admin = true 
admin.privacy_policy = true
admin.confirmed_at = Time.now
puts admin.inspect
admin.save!

(1..10).each do |i| 

  user = User.where(email: "user#{i}@tu-dresden.de").first_or_initialize(username: "user#{i}", password: 'test1234', password_confirmation: 'test1234')
  user.confirmed_at = Time.now
  user.privacy_policy = true
  puts user.inspect
  user.save!
end

(1..20).each do |i|
  tag =Tag.create(name: Faker::Lorem.word, description: Faker::Lorem.words(20).join(' '))
  puts tag.inspect
end

(1..5).each do |i|
  group = Group.new(title: Faker::Company.name, description: Faker::Lorem.words.join(' '), url: "http://#{Faker::Internet.domain_name}", group_type: ['lecture', 'topic', 'study'].sample)
  group.creator = User.first
  group.tags << add_random_tags
  group.save!
  puts group.inspect
end

Group.all.each do |group| 
  (1..x.sample).each do |i|
    question = group.questions.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    question.author_id = User.all.sample.id
    question.tags << add_random_tags
    question.save!
    puts question.inspect
    
    announcement = group.announcements.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    announcement.author_id = User.all.sample.id
    announcement.tags << add_random_tags
    announcement.save!
    puts announcement.inspect

    topic = group.topics.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    topic.author_id = User.all.sample.id
    topic.tags << add_random_tags
    topic.save!
    puts topic.inspect
  end
end

# Add answers and comments to questions
Question.all.each do |question|
  (1..x.sample).each do |i|
    comment = question.comments.new(content: Faker::Lorem.words(50).join(' '))
    comment.author_id = User.all.sample.id
    comment.save!
    puts comment.inspect
    
    answer = question.answers.new(content: Faker::Lorem.words(100).join(' '))
    answer.author_id = User.all.sample.id
    answer.save!
    puts answer.inspect
  end
end

# Add comments to answer
Answer.all.each do |answer|
  (1..x.sample).each do |i|
    comment = answer.comments.new(content: Faker::Lorem.words(60).join(' '))
    comment.author_id = User.all.sample.id
    comment.save!
    puts comment.inspect
  end
end

# Add comments to announcements
Announcement.all.each do |announcement|
  (1..x.sample).each do |i|
    comment = announcement.comments.new(content: Faker::Lorem.words(50).join(' '))
    comment.author_id = User.all.sample.id
    comment.save!
    puts comment.inspect
  end
end

Topic.all.each do |topic|
  (1..x.sample).each do |i|
    comment = topic.comments.new(content: Faker::Lorem.words(50).join(' '))
    comment.author_id = User.all.sample.id
    comment.save!
    puts comment.inspect
  end
end
