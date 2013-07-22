class Answer < Post
  # attr_accessible :title, :body
  belongs_to :question, foreign_key: :parent_id, class_name: 'Question'

  validates :post_type, presence: true, inclusion: { in: %w{answer} }
  validates :question, presence: true
  validates :body, presence: true
  validates :author, presence: true
end
