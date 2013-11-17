# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  subject       :string(255)
#  content       :text
#  rating        :integer          default(0)
#  views         :integer
#  is_private    :boolean
#  author_id     :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  last_activity :datetime
#

class Question < ActiveRecord::Base 
  include Votable
  include Taggable
  include ParentPost
  include Notifiable

  has_many :answers, :dependent => :destroy
 # has_one :correct_answer, class_name: 'Answer', as: :answer_to_id

  attr_accessible :is_private


  def self.tagged_with(name)
    Tag.find_by_name!(name).question
  end

  def authors
    authors = Array.new
    authors << self.author
    self.answers.each do |answer|
      authors << answer.author
      authors += answer.comments.map(&:author)
    end
    authors.uniq
  end

  def helpful_answer
    self.answers.where(answer_to_id: self.id)
  end
end
