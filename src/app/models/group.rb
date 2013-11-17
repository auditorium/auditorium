# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type    :string(255)
#  creator_id    :integer          default(1)
#  private_posts :boolean
#  url           :string(255)
#  approved      :boolean
#  deactivated   :boolean          default(FALSE)
#

class Group < ActiveRecord::Base
  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable
  
  has_many :questions, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :videos, dependent: :destroy

  has_many :followers, through: :followings
  has_many :followings, as: :followerable
  has_many :membership_requests

  belongs_to :creator, class_name: 'User'

  attr_accessible :description, :title, :group_type, :tag_tokens, :url
  attr_reader :tag_tokens

  validates :title, presence: true
  validates :description, presence: true
  validates :creator_id, presence: true
  validates :group_type, presence: true, inclusion: { in: %w{lecture topic study} }
  
  include Notifiable

  after_create :add_creator_to_moderators

  def self.tagged_with(name)
  	Tag.find_by_name!(name).groups
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

  def moderators
    self.followings.where(role: 'moderator').collect { |f| User.find(f.follower_id) }
  end

  def members
    self.followings.where(role: 'member').collect { |f| User.find(f.follower_id) }
  end

  def is_moderator?(user)
    self.moderators.include? user
  end

  def is_member?(user)
    self.members.include? user
  end

  def add_member(user)
    membership = self.followings.find_or_initialize_by_follower_id(user.id)
    membership.role = 'member'
    membership.save!
  end

  def add_moderator(user)
    membership = self.followings.find_or_initialize_by_follower_id(user.id)

    membership.role = 'moderator'
    membership.save
  end

  def remove_member(user)
    membership = self.followings.where(follower_id: user.id).first
    membership.destroy if membership.present?
  end

  def remove_moderator(user)
    membership = self.followings.find_or_initialize_by_follower_id(user.id)

    membership.role = 'member'
    membership.save
  end

  def has_pending_membership_request?(user)
    self.membership_requests.find_by_user_id(user.id).present?
  end

  private
  def add_creator_to_moderators
    following = self.followings.build(follower_id: self.creator.id)
    following.role = 'moderator'
    following.save!
  end

end
