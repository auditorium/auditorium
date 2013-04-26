class Recording < Post
  default_scope where(:post_type => 'recording')
  scope :published, where(is_private: false)

  belongs_to :course
  attr_accessible :url

  validates :url, presence: true

  def code
  	Rack::Utils.parse_query(URI(self.url).query)['v']
  end

  def comments
  	Post.where(parent_id: self.id, post_type: 'comment')
  end
end
