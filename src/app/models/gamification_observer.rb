require "browser"

class GamificationObserver < ActiveRecord::Observer
  observe :group, :question, :announcement, :topic, :comment, :answer, :voting, :tutorial_progress, :user

  

  # def after_create(record)
  #   case record.class.name
  #   when 'Group'
  #   when 'Question'
  #     if record.author.questions.size >= 5
  #       record.author.add_badge('learning', 'silver') 
  #     end
      
  #   when 'Announcement'
  #   when 'Topic'
  #   when 'Comment'
  #   when 'Answer'
  #   when 'Voting'
  #   when 'TutorialProgress'
  #     record.user.add_badge('curious', 'bronze') if record.introduction? and record.group? and record.groups? and record.question?
  #   end
  # end

  # def after_save(record)
  #   case record.class.name
  #   when 'TutorialProgress'
  #     if !record.user.has_badge?('curious', 'silver') and record.introduction? and record.group? and record.groups? and record.question?
  #       record.user.add_badge('curious', 'silver') 
  #     end
  #   when 'Question'
  #     achieve_post_badge(record, 'learning', 'bronze', 1)
  #     achieve_post_badge(record, 'learning', 'silver', 5)
  #     achieve_post_badge(record, 'learning', 'gold', 10)
  #   when 'Comment'
  #     achieve_post_badge(record, 'commenter', 'bronze', 1)
  #     achieve_post_badge(record, 'commenter', 'silver', 5)
  #     achieve_post_badge(record, 'commenter', 'gold', 10)
  #   when 'Announcement'
  #     achieve_post_badge(record, 'significant', 'bronze', 1)
  #     achieve_post_badge(record, 'significant', 'silver', 5)
  #     achieve_post_badge(record, 'significant', 'gold', 10)
  #   when 'Topic'
  #     achieve_post_badge(record, 'something_to_say', 'bronze', 1)
  #     achieve_post_badge(record, 'something_to_say', 'silver', 5)
  #     achieve_post_badge(record, 'something_to_say', 'gold', 10)
  #   when 'Answer'
  #     achieve_post_badge(record, 'cooperative', 'bronze', 1)
  #     achieve_post_badge(record, 'cooperative', 'silver', 5)
  #     achieve_post_badge(record, 'cooperative', 'gold', 10)

  #     achieve_helpful_badge(record, 'bronze', 1)
  #     achieve_helpful_badge(record, 'silver', 5)
  #     achieve_helpful_badge(record, 'gold', 10)
  #   end
  # end

  # def before_save(record)
  #   case record.class.name
  #   when 'User'
  #     if !record.has_badge?('biographer', 'silver') and record.profile_progress_percentage == 100
  #       record.add_badge('biographer', 'silver')
  #     elsif record.has_badge?('biographer', 'silver') and record.profile_progress_percentage < 100
  #       record.remove_badge('biographer', 'silver')
  #     end
  #   end
  # end

  # private
  # def achieve_post_badge(post, title, category, threshold)
  #   if !post.author.has_badge?(title, category) and post.rating >= threshold  
  #     post.author.add_badge(title, category)
  #     post.author.save
  #   elsif post.author.has_badge?(title, category) and post.rating < threshold
  #     post.author.remove_badge(title, category)
  #     post.author.save
  #   end
  # end

  # def achieve_helpful_badge(answer, category, threshold)
  #   if !answer.author.has_badge?('helpful', category) and answer.author.answers.keep_if { |a| !a.answer_to_id.nil? }.size >= threshold
  #     answer.author.add_badge('helpful', category)
  #     answer.author.save
  #   elsif answer.author.has_badge?('helpful', category) and answer.author.answers.keep_if { |a| !a.answer_to_id.nil? }.size < threshold
  #     answer.author.remove_badge('helpful', category)
  #     answer.author.save

  #   end
  # end
end
