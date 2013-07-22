class Question < Post
  # attr_accessible :title, :body
  belongs_to :group
  has_many :answers, class_name: 'Post', :dependent => :destroy
  has_many :comments, class_name: 'Post', :dependent => :destroy
  #has_many :comments

  validates :post_type, presence: true, inclusion: { in: %w{question} }
  validates :subject, presence: true
  validates :group, presence: true
  validates :body, presence: true
  validates :author, presence: true

end
