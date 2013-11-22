# TODO:
# memberships
# 
namespace :db do
  namespace :convert do 
    desc 'migrate courses'
    task :v2 => :environment do
      #migrate courses to groups
      Course.all.each do |course|
        puts "---- START ----"
        puts "Migrate course ##{course.id}: #{course.inspect}"
        group = Group.where(id: course.lecture.id).first_or_initialize(title: course.lecture.name, description: course.description)
        
        unless group.persisted?
          puts "GROUP is persistent: #{group.inspect}"
         
          group.created_at = course.created_at
          group.approved = course.approved
          creator = course.maintainers.first
          puts "CREATOR: #{creator.inspect}"

          if creator.nil? 
            group.creator = User.find_by_email('lars.beier@tu-dresden.de')
          elsif creator.class.name.eql? 'CourseMembership' 
            group.creator = User.find(creator.user_id)
          else
            group.creator = User.find_by_email('lars.beier@tu-dresden.de')
          end

          group.group_type = 'lecture'
          group.url = course.url
          group.save!
        else
          group.description = course.description if group.description.nil? and !course.description.nil?
        end

        # add tags to group
        group_title_tag = Tag.where(name: group.title).first_or_create!
        group.tags << group_title_tag unless group.tags.include? group_title_tag

        # course.lecture, course.chair, course.institute, course.faculty, course.university
        chair_tag = Tag.where(name: course.chair.name).first_or_create!
        group.tags <<  chair_tag unless group.tags.include? chair_tag
        institute_tag = Tag.where(name: course.institute.name).first_or_create!
        group.tags << institute_tag unless group.tags.include? institute_tag
        faculty_tag = Tag.where(name: course.faculty.name).first_or_create!
        group.tags << faculty_tag unless group.tags.include? faculty_tag
        term_tag = Tag.where(name: course.term.code).first_or_create!
        group.tags << term_tag unless group.tags.include? term_tag
        group.save!
        
        puts "Created group ##{group.id}: #{group.inspect}"
        puts "---- END -----"
      end

      puts "----- START MIGRATING POSTS --------"
      Post.all.each do |post|
        puts "----- Post no. #{post.id} --------"
        case post.post_type
        when 'question'
          puts ">> MIGRATE QUESTION: #{post.inspect}"
          
          question = Question.where(id: post.id).first_or_initialize(subject: post.subject, content: post.body)

          unless question.persisted?
            question.author_id = post.author_id
            question.group_id = post.course.lecture.id
            question.views = post.views
            question.is_private = post.is_private
            question.created_at = post.created_at
            question.last_activity = post.last_activity
            question.rating = post.rating
            question.tags = Group.find(post.course.lecture.id).tags
            question.save!
          end

          puts "QUESTION SAVED: #{question.inspect}"
        when 'announcement'
          puts ">> MIGRATE ANNOUNCEMENT: #{post.inspect}"
          
          announcement = Announcement.where(id: post.id).first_or_initialize(subject: post.subject, content: post.body)

          unless announcement.persisted?
            announcement.author_id = post.author_id
            announcement.group_id = post.course.lecture.id
            announcement.views = post.views
            announcement.is_private = post.is_private
            announcement.created_at = post.created_at
            announcement.last_activity = post.last_activity
            announcement.rating = post.rating
            announcement.tags = Group.find(post.course.lecture.id).tags
            announcement.save!
          end

          puts "ANNOUNCEMENT SAVED: #{announcement.inspect}"
        when 'recording'
          puts ">> MIGRATE RECORDING: #{post.inspect}"
          
          video = Video.where(id: post.id).first_or_initialize(subject: post.subject, content: post.body)
          unless video.persisted?
            video.author_id = post.author_id
            video.group_id = post.course.lecture.id
            video.views = post.views
            video.url = post.url
            video.created_at = post.created_at
            video.last_activity = post.last_activity
            video.rating = post.rating
            video.tags = Group.find(post.course.lecture.id).tags
            video.save!
          end

          puts "RECORDING SAVED: #{video.inspect}"
        when 'answer'
          puts "MIGRATE ANSWER >> #{post.inspect}"
          answer = Answer.where(id: post.id).first_or_initialize(content: post.body, author_id: post.author_id, question_id: post.parent.id)
          unless answer.persisted?
            answer.answer_to_id = post.answer_to.id if post.answer_to.present?
            answer.rating = post.rating
            answer.created_at = post.created_at
            answer.last_activity = post.last_activity
            answer.save!
          end

          puts "ANSWER SAVED: #{answer.inspect}"
        when 'comment'
          puts "MIGRATE COMMENT >> #{post.inspect}"
          comment = Comment.where(id: post.id).first_or_initialize(content: post.body, author_id: post.author_id)

          unless comment.persisted?
            comment.rating = post.rating
            comment.created_at = post.created_at
            comment.last_activity = post.last_activity
            comment.commentable_id = post.parent.id
            comment.commentable_type = (post.parent.post_type.eql?('recording') ? Video : post.parent.post_type)
            comment.save!
          end
          puts "COMMENT SAVED #{comment.inspect}"
        end
      end

      Rating.all.each do |rating|
        puts "------ VOTING ------"
        post = Post.where(id: rating.post_id).first
        if post.present?
          voting = Voting.where(id: rating.id).first_or_initialize(user_id: rating.user_id, votable_id: post.id, votable_type: (post.post_type.eql?('recording') ? Video : post.post_type))
          
          unless voting.persisted?
            voting.value = rating.points
            voting.save! 
          end
          puts "---- VOTING SAVED #{voting.inspect} ----- "
        end
      end

      EmailSetting.all.each do |email_setting|
        puts "---- SETTING #{email_setting.inspect} ----- "

        setting = Setting.where(id: email_setting.id, user_id: email_setting.user_id).first_or_initialize(receive_email_notifications: email_setting.emails_for_subscribtions, receive_emails_when_author: email_setting.notification_when_author)

        unless setting.persisted?
          setting.save!
          puts "---- SETTING SAVED #{setting.inspect} ----- "
        end
      end

      CourseMembership.all.each do |membership|
        puts "---- MEMBERSHIP #{membership.inspect} ----- "
        course = Course.find(membership.course_id)
        role = ((membership.membership_type.eql? 'maintainer' or membership.membership_type.eql? 'editor') ? 'moderator' : 'member')
        following = Following.where(follower_id: membership.user_id, followerable_id: course.lecture.id, followerable_type: Group).first_or_initialize
        following.role = role
        following.receive_notifications = membership.receive_emails
        following.created_at = membership.created_at
        following.save!
        puts "---- FOLLOWING SAVED #{following.inspect} ----- "
      end
    end
  end
end

# == Schema Information
#
# Table name: followings
#
#  id                    :integer          not null, primary key
#  follower_id           :integer
#  followerable_id       :integer
#  followerable_type     :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  role                  :string(255)      default("member")
#  receive_notifications :boolean          default(TRUE)
#

# == Schema Information
#
# Table name: course_memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  course_id       :integer
#  membership_type :string(255)      default("member")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifyable_id   :integer
#  notifyable_type :string(255)
#  receive_emails  :boolean          default(TRUE)
#