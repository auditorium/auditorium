class Post < ActiveRecord::Base
  belongs_to :parent, class_name: 'Post'
  has_many :children, foreign_key: :parent_id, class_name: 'Post', :dependent => :destroy

  belongs_to :answer_to, class_name: 'Post'
  has_one :answer, foreign_key: :answer_to_id, class_name: 'Post'

  belongs_to :course
  belongs_to :author, class_name: 'User'
   
  has_many :tags 
  
  scope :not_answered, where(:answer_to_id => nil, :post_type => 'question')

  attr_accessible :body, :subject, :post_type, :parent_id, :course_id, :author_id, :answer_to_id, :is_private

  validates :post_type, presence: true, inclusion: { in: %w{question answer info comment} }
  validates :subject, presence: true
  validates :course, presence: true
  validates :body, presence: true
  validates :author, presence: true

  define_index do
    indexes subject
    indexes body
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  after_save do
    author.update_score if rating_changed?
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
    if self.parent.nil?
      self
    else
      if self.parent.parent.nil?
        self.parent # answer or comment
      else
        self.parent.parent # comment to an answer
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
end
