class Institute < ActiveRecord::Base
  belongs_to :faculty
  has_many :chairs, :dependent => :destroy

  attr_accessible :name, :faculty_id

  validates :name, presence: true
  validates :faculty, presence: true

  define_index do
    indexes name
  end

  def to_s 
    self.name
  end

  def parent
    self.faculty
  end

  def children
    self.chairs
  end

end
