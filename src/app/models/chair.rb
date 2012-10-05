class Chair < ActiveRecord::Base
  has_many :lectures, :dependent => :destroy
  belongs_to :institute

  attr_accessible :name, :institute_id, :chair_id, :url

  validates :name, presence: true
  validates :institute, presence: true

  define_index do
    indexes :name
  end

  def to_s 
    self.name
  end

  def parent
    self.institute
  end

  def children 
    self.lectures
  end

  def lectures_by_current
    self.lectures.group_by{ |lecture| lecture.has_current_course? }
  end

  def current_lectures
    self.lectures.keep_if { |lecture| lecture.has_current_course? }
  end

  def old_lectures
    self.lectures.keep_if { |lecture| not lecture.has_current_course? }
  end
end
