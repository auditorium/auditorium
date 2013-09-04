class Answer < ActiveRecord::Base 
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
