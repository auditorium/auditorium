# == Schema Information
#
# Table name: recordings
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :text
#  rating     :integer          default(0)
#  views      :integer
#  url        :string(255)
#  is_private :boolean
#  author_id  :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recording < ActiveRecord::Base 
  scope :published, where(is_private: false)

  belongs_to :course
  belongs_to :author, class_name: 'User'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  attr_accessible :subject, :content, :group, :url

  validates :subject, presence: true
  validates :group, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :url, presence: true


  def code
  	Rack::Utils.parse_query(URI(self.url).query)['v']
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).recording
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
end
