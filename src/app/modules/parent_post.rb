 module ParentPost 
  def self.included(base)
    base.belongs_to :group
    base.belongs_to :author, class_name: 'User'

    base.has_many :comments, as: :commentable, dependent: :destroy

    base.validates :subject, presence: true
    base.validates :group, presence: true
    base.validates :content, presence: true
    base.validates :author, presence: true

    base.attr_accessible :subject, :content, :group
  end

  def subscribed?(user)
    self.group.followers.include? user
  end

  def origin
    self
  end
end