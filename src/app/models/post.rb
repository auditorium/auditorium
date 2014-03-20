# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  subject         :string(255)
#  body            :text
#  post_type       :string(255)
#  parent_id       :integer
#  answer_to_id    :integer
#  course_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  author_id       :integer
#  rating          :integer          default(0)
#  notifyable_id   :integer
#  notifyable_type :string(255)
#  needs_review    :boolean          default(FALSE)
#  is_private      :boolean          default(FALSE)
#  last_activity   :datetime
#  views           :integer          default(0)
#  url             :string(255)
#  group_id        :integer
#

class Post < ActiveRecord::Base
  scope :not_answered, where(:answer_to_id => nil, :post_type => 'question')
  attr_accessible :body, :subject, :parent_id, :course_id, :author_id, :answer_to_id, :is_private, :tag_tokens, :post_type
  attr_reader :tag_tokens

  has_many :comments, as: :commentable

  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  belongs_to :parent, class_name: 'Post'
  has_many :children, foreign_key: :parent_id, class_name: 'Post', :dependent => :destroy

  belongs_to :answer_to, class_name: 'Post'
  has_one :answer, foreign_key: :answer_to_id, class_name: 'Post'

  belongs_to :course
  belongs_to :group
  belongs_to :author, class_name: 'User'
   
  has_many :tags, through: :taggings
  
  after_save do
    author.update_score if rating_changed?
  end
  
  # tagging
  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end 
  end 

  def tag_tokens=(tokens)  
    self.tag_ids = Tag.ids_from_tokens(tokens)  
  end  


  # get answers and comments to this post if any
  def answers
   answers = Post.find_all_by_post_type_and_parent_id('answer', self.id)
   answers.sort{|x,y| y.rating <=> x.rating }
  end

  def answered?
  !self.answer_to_id.nil?
  end

  def comments
   Post.find_all_by_post_type_and_parent_id('comment', self.id)
  end

  def follow_up_questions 
    Post.find_all_by_post_type_and_parent_id('question', self.id)
  end

  def is_parent?
   self.parent_id == nil
  end

  def author_name
    if not self.author.nil?
      return self.author.full_name
    else
      return "deleted person"
    end        
  end

  def answered?
    if self.post_type.eql? 'question'
      self.answers.each do |answer|
        if answer.answer_to_id
          return true
        end
      end
    end

    false # question is not answered yet
  end

  def origin
    if self.post_type.eql? 'question' or self.parent_id.nil?
      self
    else
      if self.parent.parent.nil?
        self.parent # answer or comment
      else
        unless self.parent.post_type.eql? 'question'
          self.parent.parent  # comment to an answer
        else
          self.parent
        end
      end
    end
  end

  # methods for autocompletion
  def course_name=(name)
    course = Course.find_by_name(name)
    if course
      self.course_id = course.id
    else
      errors[:course_name] << "Invalid name entered"
    end
  end

  def course_name
    Course.find(course_id).name if course_id
  end

  def top_rated?
    self.rating >= 10
  end

  def reports
    Report.find_all_by_post_id(self.id)
  end

  def too_many_reports?
    self.reports.count >= 4
  end

  def all_authors
    @authors = Array.new
    @authors << self.author

    self.children.each do |child|
      @authors << child.author
      child.children.each do |grandchild| 
        @authors << grandchild.author
      end
    end

    @authors.uniq
  end

  def code
    if self.post_type.eql? 'recording' 
      Rack::Utils.parse_query(URI(self.url).query)['v']
    else
      "No recording."
    end
  end
end
