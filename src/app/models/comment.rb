# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  author_id        :integer
#  content          :text
#  rating           :integer          default(0)
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ActiveRecord::Base
  include Votable
  include Notifiable
  
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'
  
  attr_accessible :author_id, :content, :rating

  validates :commentable, presence: true
  validates :content, presence: true
  validates :author, presence: true

  define_index do
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def origin
    if self.commentable.instance_of?(Answer)
      self.commentable.question
    else
      self.commentable
    end
  end
end
