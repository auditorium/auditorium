# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  first_name             :string(255)
#  last_name              :string(255)
#  title                  :string(255)      default("")
#  website                :string(255)
#  alternative_email      :string(255)
#  score                  :integer          default(0)
#  authentication_token   :string(255)
#  role                   :string(255)
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  privacy_policy         :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  before_save :ensure_authentication_token

  devise :database_authenticatable, :trackable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me, :email, :alternative_email, :password, :password_confirmation, :current_password
  attr_accessible :username, :title, :first_name, :last_name, :website, :privacy_policy
  cattr_accessor :current
  
  has_one :setting, dependent: :destroy

  has_many :votings

  has_many :recordings, :foreign_key => :author_id
  has_many :announcements, :foreign_key => :author_id
  has_many :questions, :foreign_key => :author_id
  has_many :topics, :foreign_key => :author_id
  has_many :answers, :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id
  has_many :notifications, :foreign_key => :receiver_id
  has_one :email_setting, :dependent => :destroy


  has_many :followings, foreign_key: 'follower_id', dependent: :destroy
  with_options through: :followings, source: :followerable do |tag|
    tag.has_many :groups, source_type: 'Group'
  end

  # ---- OLD ------

  has_many :events, foreign_key: :tutor_id # as tutor
  has_many :lecture_memberships, :dependent => :destroy
  has_many :course_memberships, :dependent => :destroy
  has_many :faculty_memberships, :dependent => :destroy
  has_many :lectures, :through => :lecture_memberships  # lecture maintainers
  has_many :courses,    :through => :course_memberships  # as student or course-editor (tutor,  professor,  etc.)
  has_many :faculties,  :through => :faculty_memberships
  has_many :posts, :foreign_key => :author_id

  # ----- end of old ----
  
  validates_uniqueness_of :email
  validates :privacy_policy, acceptance: { accept: true }, :on => :create
  validates :username, :presence => true, :format => { :with => /^[A-Za-zäöüÄÖÜß0-9_\-\.]+$/, :message => I18n.t('validation.unsupported_signs', signs: '[A-Za-zäöüÄÖÜß0-9_-.]') }
  validates_uniqueness_of :username
  
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

  def will_receive_email_notifications(group)
    self.followings.find_by_followerable_id(group.id).receive_notifications
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

  def self.required_fields(klass)
    [:current_sign_in_at, :last_sign_in_at, :sign_in_count]
  end

  def update_tracked_fields!(request)
    old_current, new_current = self.current_sign_in_at, Time.now.utc
    self.last_sign_in_at = old_current || new_current
    self.current_sign_in_at = new_current

    #old_current, new_current = self.current_sign_in_ip, request.remote_ip
    #self.last_sign_in_ip = old_current || new_current
    #self.current_sign_in_ip = new_current

    self.sign_in_count ||= 0
    self.sign_in_count += 1

    save(:validate => false) or raise "Devise trackable could not save #{inspect}." \
      "Please make sure a model using trackable can be saved at sign in."
  end

  
end
