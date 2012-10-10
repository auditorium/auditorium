class Notification < ActiveRecord::Base
  belongs_to :receiver, :class_name => 'User'
  belongs_to :sender, :class_name => 'User'
  belongs_to :notifyable, :polymorphic => true
  
  attr_accessible :title, :body, :read, :receiver, :sender, :notifyable_id, :notifyable_type
  
  validate :title, :presence => true
  validate :body, :presence => true
  validate :sender, :presence => true
  validate :receiver, :presence => true
  validate :notifyable_type, :presence => true, inclusion: { in: %w{Post Rating CourseMembership LectureMembership} }
  validate :notifyable_id, :presence => true

  def path
    if self.notifyable_type.eql? 'Post' or self.notifyable_type.eql? 'Rating'
      post = Post.find self.notifyable_id
      post
    end
  end

  def notifyable_object
    if self.notifyable_type.eql? 'Post' 
      post = Post.find(self.notifyable_id) if Post.exists?(self.notifyable_id)
    else
      return nil
    end
  end

  def title 
    if self.notifyable_type.eql?'Post'
      post = self.notifyable_object
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
end
