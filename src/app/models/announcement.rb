class Announcement < Post
  default_scope where(:post_type => 'announcement')

  belongs_to :group
  # has_many :comments, class_name: 'Post', :dependent => :destroy

  validates :post_type, presence: true, inclusion: { in: %w{announcement} }
  validates :subject, presence: true
  validates :group, presence: true
  validates :body, presence: true
  validates :author, presence: true
end
