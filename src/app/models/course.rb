class Course < ActiveRecord::Base

  belongs_to :lecture
  belongs_to :term
  has_many :posts, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :course_memberships, :dependent => :destroy
  has_many :users, through: :course_memberships
  
  attr_accessible :description, :name, :beginDate, :endDate, :term_id, :lecture_id, :maintainer_id, :sws, :url

  validates :name, presence: true
  validates :lecture, presence: true
  validates :term,  presence: true

  define_index do
    indexes :name
    indexes description
    indexes semester
    indexes url

    has lecture_id
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  #scope :unmaintained,includes(:course_memberships).where(:course_memberships)
  def name_with_term(option = { short: true })
    if self.name.length > 50 && :short == true
      "#{self.name[0..50].titleize}... (#{self.term.code})"
    else
      "#{self.name.titleize} (#{self.term.code})"
    end
  end
  
  def parent
    self.lecture.parent
  end
  
  def followers
    self.course_memberships.map {|membership|
      membership.user
    }
  end

  def participants
    posts = Post.find_all_by_course_id self.id
    participants = posts.map {|p| p.author }
    participants.uniq
  end
  
  def moderators
    moderators = Array.new
    moderators = CourseMembership.where('(membership_type = ? or membership_type = ?) and course_id = ?', 'maintainer', 'editor', self.id).map(&:user)
    moderators = User.where('admin = true') if moderators.empty?
  end

  def children
    self.events
  end

  def faculty
    self.lecture.chair.institute.faculty
  end

  def questions
    questions = Post.order('created_at ASC').where('post_type = ? and course_id = ?','question', self.id)
  end
  
  def infos
    Post.order('created_at ASC').where('post_type = ? and course_id = ?','info', self.id)
  end

  def is_now?
    self.term.beginDate <= Date.today and Date.today <= self.term.endDate
  end

  def to_s 
    "#{self.name} #{self.term.code}"
  end
  
  def maintainers
    maintainers = CourseMembership.find_all_by_course_id_and_membership_type(self.id, 'maintainer')
  end
  
  def editors
    editors = CourseMembership.find_all_by_course_id_and_membership_type(self.id, 'editor')
  end

  def has_maintainer?
    not self.maintainer.nil?
  end
  
  def posts_per_day
    self.posts.group_by{ |post| post.created_at.to_date.beginning_of_day }
  end

  def next
    current_term = self.term
    if current_term.term_type.eql? 'ss'
      next_term = Term.where("term_type = 'ws' and beginDate >= ? and endDate <= ?", Date.new(current_term.endDate.year, 10, 1), Date.new(current_term.endDate.year+1, 3, 31)).first
    else
      next_term = Term.where("term_type = 'ss' and beginDate >= ? and endDate <= ?", Date.new(current_term.endDate.year, 4, 1), Date.new(current_term.endDate.year, 9, 30)).first
    end
    
    course = Course.where(:lecture_id => self.lecture.id, :term_id => next_term.id).first if next_term
  end
  
  def previous
    current_term = self.term
    if current_term.term_type.eql? 'ss'
      previous_term = Term.where("term_type = 'ws' and beginDate >= ? and endDate <= ?", Date.new(current_term.beginDate.year-1, 10, 1), Date.new(current_term.beginDate.year, 3, 31)).first
    else
      previous_term = Term.where("term_type = 'ss' and beginDate >= ? and endDate <= ?", Date.new(current_term.beginDate.year, 4, 1), Date.new(current_term.beginDate.year, 9, 30)).first
    end
    course = Course.where(:lecture_id => self.lecture.id, :term_id => previous_term.id).first if previous_term
  end
end
