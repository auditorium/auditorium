# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  content       :text
#  rating        :integer          default(0)
#  question_id   :integer
#  author_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  answer_to_id  :integer
#  last_activity :datetime
#

class Answer < ActiveRecord::Base 
  include Votable
  include Notifiable
  
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :comments, as: :commentable, dependent: :destroy


  attr_accessible :content, :question_id, :author_id

  validates :question_id, presence: true
  validates :content, presence: true
  validates :author_id, presence: true

  def origin
    self.question
  end

  def is_helpful?
    !self.answer_to_id.nil?
  end
end
