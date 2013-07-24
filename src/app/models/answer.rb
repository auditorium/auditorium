class Answer < ActiveRecord::Base 
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :content, :question, :author

  validates :question, presence: true
  validates :content, presence: true
  validates :author, presence: true
end
