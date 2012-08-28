class Faculty < ActiveRecord::Base
  has_many :institutes, :dependent => :destroy
  attr_accessible :name
  has_many :faculty_memberships
  has_many :users, :through => :faculty_membership
  validates :name, presence: true

  define_index do
    indexes name
  end

  def to_s 
    self.name
  end

  def parent
    nil
  end

  def children
    self.institutes
  end

  def courses
    Course.select {|course| course.faculty == self}
  end

  def courses_paginated(page)
    Course.page(page).select {|course| course.faculty == self}
  end

end
