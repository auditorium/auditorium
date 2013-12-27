# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  receiver_id     :integer
#  sender_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  body            :text
#  read            :boolean          default(FALSE)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#

class Notification < ActiveRecord::Base
  belongs_to :receiver, :class_name => 'User'
  belongs_to :sender, :class_name => 'User'
  belongs_to :notifiable, :polymorphic => true
  
  attr_accessible :title, :body, :read, :receiver, :sender, :notifiable_id, :notifiable_type, :notifiable
  
  validate :title, :presence => true
  validate :body, :presence => true
  validate :sender, :presence => true
  validate :receiver, :presence => true
  validate :notifiable_type, :presence => true
  validate :notifiable_id, :presence => true

  def for_post?
    %{Question Announcement Topic Answer Comment Video}.include? self.notifiable_type
  end

  def path
    if self.notifiable_type.eql? 'Post' or self.notifiable_type.eql? 'Rating'
      post = Post.find self.notifiable_id
      post
    end
  end

  def notifiable_object
    if self.notifiable_type.eql? 'Post' 
      post = Post.find(self.notifiable_id) if Post.exists?(self.notifiable_id)
    else
      return nil
    end
  end

  def title 
    if self.notifiable_type.eql?'Post'
      post = self.notifiable_object
      if post.nil?
        "Something went wrong..."
      else
        "#{post.author} has made a new announcement in '#{post.course.name_with_term}'" if post.post_type.eql? 'info' 
        "#{post.author} has asked a new question in '#{post.course.name_with_term}'" if post.post_type.eql? 'question'
        "#{post.author} has commented on '#{post.parent.subject}'" if post.post_type.eql? 'comment'
        "#{post.author} has answered the question '#{post.parent.subject}'" if post.post_type.eql? 'answer'
      end
    end
  end

  def body
    self.title
  end

  def group
    case self.notifiable_type
    when 'Question'
      group = Question.find(self.notifiable_id).group
    when 'Announcement'
      group = Announcement.find(self.notifiable_id).group
    when 'Topic'
      group = Topic.find(self.notifiable_id).group
    when 'Answer'
      group = Answer.find(notifiable_id).group
    when 'Comment'
      group = Comment.find(notifiable_id).group
    else
      group = nil
    end

    group
  end
end
