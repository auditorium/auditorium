# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :text
#  rating      :integer          default(0)
#  question_id :integer
#  author_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Answer < ActiveRecord::Base 
  include Votable
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :content, :question, :author

  validates :question, presence: true
  validates :content, presence: true
  validates :author, presence: true

  define_index do
    indexes content
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def origin
    self.question
  end
end
