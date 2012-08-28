class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :trackable
  # TODO turn on confirmable in production
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me, :email, :alternative_email, :password, :password_confirmation
  attr_accessible :username, :title, :first_name, :last_name, :website
  # attr_accessible :title, :body
  
  has_many :events, foreign_key: :tutor_id # as tutor
  has_many :lecture_memberships
  has_many :course_memberships
  has_many :faculty_memberships
  has_many :lectures, :through => :lecture_memberships  # lecture maintainers
  has_many :courses,    :through => :course_memberships  # as student or course-editor (tutor,  professor,  etc.)
  has_many :faculties,  :through => :faculty_memberships
  has_many :posts, :foreign_key => :author_id
  has_many :notifications, :foreign_key => :receiver_id
  
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  
  define_index do
    indexes email
    indexes title
    indexes username
  end

  # returns the full user name if first and last name was specified in the user's profile...
  def full_name
    
    if (not self.first_name.nil? and not self.first_name.eql? "") or (not self.last_name.nil? and not self.last_name.eql? "")
      "#{self.first_name} #{self.last_name}" 
    elsif self.username
      self.username 
    else
      # wrapped email only prefix

      parsed_email = self.email.split('@')
      parsed_email[0]
    end
  end

  def to_s
    full_name
  end

  # how many points has the user gained with his posts?
  def update_score
    self.score = posts.inject(0) { |score, post| score += post.rating }
    save
  end

  def lecture_membership course
    LectureMembership.find_by_user_id_and_lecture_id(self.id, course.id)
  end

  def course_membership course
    CourseMembership.find_by_user_id_and_course_id(self.id, course.id)
  end

  def membership_type(course)
    membership = self.course_membership course
    membership.membership_type if membership
  end
  
  def subcribed_to?(course)
    membership = self.course_membership course
  end

  def is_admin?
    self.admin
  end
  
  def is_course_member?(course)
    membership = self.course_membership course
    membership.membership_type.eql? 'member' if membership
  end
  
  def is_course_maintainer?(course)
    membership = self.course_membership course
    membership.membership_type.eql? 'maintainer' if membership
  end
  
  def is_course_editor?(course)
    membership = self.course_membership course
    membership.membership_type.eql? 'editor' if membership
  end
  
  def is_lecture_member?(lecture)
    membership = self.lecture_membership lecture
    membership.membership_type.eql? 'member' if membership
  end
  
  def is_lecture_maintainer?(lecture)
    membership = self.lecture_membership lecture
    membership.membership_type.eql? 'maintainer' if membership
  end
  
  def is_lecture_editor?(lecture)
    membership = self.lecture_membership lecture
    membership.membership_type.eql? 'editor' if membership
  end
  
  def membership_type(course)
    membership = CourseMembership.find_by_user_id_and_course_id(self.id, course.id)
    membership.membership_type if membership
  end

  def may_edit_course course
    self.admin? or self.is_course_editor?(course) or self.is_course_maintainer?(course) or self.may_edit_lecture(course.lecture)
  end

  def may_edit_lecture lecture
    self.admin? or self.is_lecture_editor?(lecture) or self.is_lecture_maintainer?(lecture)
  end

  def faculty_id
    if self.faculties.empty?
      nil
    else
      self.faculties.first.id 
    end
  end
  
  def courses_by_faculty
    self.courses.group_by{ |course| course.lecture.chair.institute.faculty.name }
  end
  
  def posts_of_followed_courses_per_day
    posts = Post.order('created_at DESC').where('post_type = ? or post_type = ?', 'question', 'info').all
    posts = posts.select{|post| self.courses.include? post.course }
    posts.group_by{ |post| post.created_at.to_date.beginning_of_day }
  end
  
  def unread_notifications
    self.notifications.select { |notification| notification.read == false }
  end

  def notifications
    Notification.where('receiver_id = ?', self.id).order('created_at DESC')
  end

  # A callback method used to deliver confirmation
  # instructions on creation. This can be overriden
  # in models to map to a nice sign up e-mail.
  def send_on_create_confirmation_instructions
    if self.email.match /tu-dresden.de$/
      Rails.logger.debug "TU DRESDEN EMAIL! :)"
      send_devise_notification(:confirmation_instructions)
    else
      Rails.logger.debug "NO TU DRESDEN EMAIl! :("
      false
    end
  end

  def send_unlock_instructions
    if self.email.match /tu-dresden.de$/
      Rails.logger.debug "TU DRESDEN EMAIL! :)"
      send_devise_notification(:confirmation_instructions)
    else
      Rails.logger.debug "NO TU DRESDEN EMAIl! :("
      false
    end
  end


end
