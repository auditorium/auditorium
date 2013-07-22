class Answer < Post
  default_scope where(:post_type => 'answer')
  belongs_to :question, foreign_key: :parent_id, class_name: 'Question'
  has_many :comments, as: :commentable, :dependent => :destroy

  validates :post_type, presence: true, inclusion: { in: %w{answer} }
  validates :question, presence: true
  validates :body, presence: true
  validates :author, presence: true
end
