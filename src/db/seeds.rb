# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first) 
x = [1,2,3,4,5]
(1..5).each do |i|
  group = Group.new(title: Faker::Company.name, description: Faker::Lorem.words.join(' '), url: "http://#{Faker::Internet.domain_name}", group_type: ['lecture', 'topic', 'learning'].sample)
  group.creator = User.first
  group.save!
  puts group.inspect
end

Group.all.each do |group| 
  (1..x.sample).each do |i|
    question = group.questions.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    question.author_id = User.all.sample.id
    question.save!
    puts question.inspect
    
    announcement = group.announcements.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    announcement.author_id = User.all.sample.id
    announcement.save!
    puts announcement.inspect

    topic = group.topics.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
    topic.author_id = User.all.sample.id
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