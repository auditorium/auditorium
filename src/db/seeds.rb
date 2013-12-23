# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first) 
# x = [1,2,3,4,5]

# def self.add_random_tags 
#   a = (0..Tag.all.size).to_a
#   a.select {|_| rand(2).zero? }
#   Tag.where(id: a)
# end

# x = (1..5).to_a

# admin = User.where(email: 'admin@tu-dresden.de').first_or_initialize(username: 'admin', password: 'test1234', password_confirmation: 'test1234')
# admin.admin = true 
# admin.privacy_policy = true
# admin.confirmed_at = Time.now
# puts admin.inspect
# admin.save!

# (1..10).each do |i| 

#   user = User.where(email: "user#{i}@tu-dresden.de").first_or_initialize(username: "user#{i}", password: 'test1234', password_confirmation: 'test1234')
#   user.confirmed_at = Time.now
#   user.privacy_policy = true
#   puts user.inspect
#   user.save!
# end

# (1..20).each do |i|
#   tag =Tag.create(name: Faker::Lorem.word, description: Faker::Lorem.words(20).join(' '))
#   puts tag.inspect
# end

# (1..5).each do |i|
#   group = Group.new(title: Faker::Company.name, description: Faker::Lorem.words.join(' '), url: "http://#{Faker::Internet.domain_name}", group_type: ['lecture', 'topic', 'study'].sample)
#   group.creator = User.first
#   group.tags << add_random_tags
#   group.save!
#   puts group.inspect
# end

# Group.all.each do |group| 
#   (1..x.sample).each do |i|
#     question = group.questions.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
#     question.author_id = User.all.sample.id
#     question.tags << add_random_tags
#     question.save!
#     puts question.inspect
    
#     announcement = group.announcements.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
#     announcement.author_id = User.all.sample.id
#     announcement.tags << add_random_tags
#     announcement.save!
#     puts announcement.inspect

#     topic = group.topics.new(subject: Faker::Lorem.words(10).join(' ').capitalize, content: Faker::Lorem.words(100).join(' '))
#     topic.author_id = User.all.sample.id
#     topic.tags << add_random_tags
#     topic.save!
#     puts topic.inspect
#   end
# end

# # Add answers and comments to questions
# Question.all.each do |question|
#   (1..x.sample).each do |i|
#     comment = question.comments.new(content: Faker::Lorem.words(50).join(' '))
#     comment.author_id = User.all.sample.id
#     comment.save!
#     puts comment.inspect
    
#     answer = question.answers.new(content: Faker::Lorem.words(100).join(' '))
#     answer.author_id = User.all.sample.id
#     answer.save!
#     puts answer.inspect
#   end
# end

# # Add comments to answer
# Answer.all.each do |answer|
#   (1..x.sample).each do |i|
#     comment = answer.comments.new(content: Faker::Lorem.words(60).join(' '))
#     comment.author_id = User.all.sample.id
#     comment.save!
#     puts comment.inspect
#   end
# end

# # Add comments to announcements
# Announcement.all.each do |announcement|
#   (1..x.sample).each do |i|
#     comment = announcement.comments.new(content: Faker::Lorem.words(50).join(' '))
#     comment.author_id = User.all.sample.id
#     comment.save!
#     puts comment.inspect
#   end
# end

# Topic.all.each do |topic|
#   (1..x.sample).each do |i|
#     comment = topic.comments.new(content: Faker::Lorem.words(50).join(' '))
#     comment.author_id = User.all.sample.id
#     comment.save!
#     puts comment.inspect
#   end
# end

# ============= BADGES ============
#  id          :integer          not null, primary key
#  description :text
#  title       :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
Badge.delete_all
Badge.create(title: 'learning', description: 'first question with +1', category: 'bronze')
Badge.create(title: 'learning', description: 'first question with +5', category: 'silver')
Badge.create(title: 'learning', description: 'first question with +10', category: 'gold')

Badge.create(title: 'commenter', description: 'first comment with +1', category: 'bronze')
Badge.create(title: 'commenter', description: 'first comment with +5', category: 'silver')
Badge.create(title: 'commenter', description: 'first comment with +10', category: 'gold')

Badge.create(title: 'cooperative', description: 'first answer with +1', category: 'bronze')
Badge.create(title: 'cooperative', description: 'first answer with +5', category: 'silver')
Badge.create(title: 'cooperative', description: 'first answer with +10', category: 'gold')

Badge.create(title: 'helpful', description: 'first answer marked as helpful', category: 'bronze')
Badge.create(title: 'helpful', description: 'five answers marked as helpful', category: 'silver')
Badge.create(title: 'helpful', description: 'ten answers marked as helpful', category: 'gold')

Badge.create(title: 'significant', description: 'first announcement with +1', category: 'bronze')
Badge.create(title: 'significant', description: 'first announcement with +5', category: 'silver')
Badge.create(title: 'significant', description: 'first announcement with +10', category: 'gold')

Badge.create(title: 'something_to_say', description: 'first topic with +1', category: 'bronze')
Badge.create(title: 'something_to_say', description: 'first topic with +5', category: 'silver')
Badge.create(title: 'something_to_say', description: 'first topic with +10', category: 'gold')

Badge.create(title: 'moderator', description: 'become a moderator', category: 'silver')
Badge.create(title: 'party', description: 'first group created and granted', category: 'silver')

Badge.create(title: 'modern_browser', description: 'using a modern web browser', category: 'bronze')
Badge.create(title: 'biographer', description: 'filling out the profile', category: 'silver')
Badge.create(title: 'curious', description: 'absolved all guides within auditorium', category: 'silver')

Badge.create(title: 'rewarding', description: 'first up vote', category: 'bronze')
Badge.create(title: 'rewarding', description: 'first 25 up votes', category: 'silver')
Badge.create(title: 'rewarding', description: 'first 50 up votes', category: 'gold')

Badge.create(title: 'critical', description: 'first down vote', category: 'bronze')
Badge.create(title: 'critical', description: 'first 25 down votes', category: 'silver')
Badge.create(title: 'critical', description: 'first 50 down votes', category: 'gold')

Badge.create(title: 'editor', description: 'first time edit of a post', category: 'bronze')

Badge.create(title: 'first_step', description: 'registered on auditorium and confirmed email address', category: 'bronze')

Level.delete_all
Level.create(number: 0, threshold: 0, description: 'Basic Level')
Level.create(number: 1, threshold: 100, description: 'First Level')
Level.create(number: 2, threshold: 250, description: 'Second Level')
Level.create(number: 3, threshold: 500, description: 'Third Level')
Level.create(number: 4, threshold: 1000, description: 'Fourth Level')
Level.create(number: 5, threshold: 2000, description: 'Fifth Level')
Level.create(number: 6, threshold: 4000, description: 'Sixth Level')

User.all.each do |user|
  user.level_id = Level.find_by_number(0).id
  user.save
end

# Badge.create(title: 'habitue', description: 'two days in a row active', category: 'bronze')
# Badge.create(title: 'habitue', description: 'one week in a row active', category: 'silver')
# Badge.create(title: 'habitue', description: 'two weeks in a row active', category: 'gold')

