class User < ActiveRecord::Base
  before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :trackable
  # TODO turn on confirmable in production
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me, :email, :alternative_email, :password, :password_confirmation
  attr_accessible :username, :title, :first_name, :last_name, :website
  cattr_accessor :current
  
  # attr_accessible :title, :body
  
  has_many :votings

  has_many :events, foreign_key: :tutor_id # as tutor
  has_many :lecture_memberships, :dependent => :destroy
  has_many :course_memberships, :dependent => :destroy
  has_many :faculty_memberships, :dependent => :destroy
  has_many :lectures, :through => :lecture_memberships  # lecture maintainers
  has_many :courses,    :through => :course_memberships  # as student or course-editor (tutor,  professor,  etc.)
  has_many :faculties,  :through => :faculty_memberships
  has_many :posts, :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id
  has_many :notifications, :foreign_key => :receiver_id
  has_one :email_setting, :dependent => :destroy


  has_many :followings, foreign_key: 'follower_id', dependent: :destroy
  with_options through: :followings, source: :followerable do |tag|
    tag.has_many :groups, source_type: 'Group'
  end
  
  validates_uniqueness_of :email
  #validates :username, :presence => true, :format => { :with => /^[A-Za-z0-9_\-\.]+$/, :message => "contains unsupported signs. Plese only use those signs: [A-Za-z0-9_-.]." }
  #validates_uniqueness_of :username
  

  define_index do
    indexes email
    indexes title
    indexes username
  end

  # returns the full user name if first and last name was specified in the user's profile...
  def full_name
    
    if (not self.first_name.nil? and not self.first_name.eql? "") or (not self.last_name.nil? and not self.last_name.eql? "")
      "#{self.title} #{self.first_name} #{self.last_name}".strip
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

  def is_follower?(post)
    post.group.followers.include? self
  end

  def role_in_group(group)
    if group.followers.include? self
      group.followings.find_by_follower_id(self.id).role 
    else
      'no_member'
    end
  end

  def groups_as(role)
    if role.eql? 'creator'
      groups = Group.where(creator_id: self.id)
    else
      groups = Group.where(id: self.followings.where(role: role).map(&:followerable_id))
    end
  end

  # A callback method used to deliver confirmation
  # instructions on creation. This can be overriden
  # in models to map to a nice sign up e-mail.
  def send_on_create_confirmation_instructions
    if self.email.match /tu-dresden.de$/
      send_confirmation_instructions
    else
      false
    end
  end

  def send_unlock_instructions
    if self.email.match /tu-dresden.de$/
      send_confirmation_instructions
    else
      false
    end
  end

  
end
