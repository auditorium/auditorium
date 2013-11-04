# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :text
#  rating     :integer          default(0)
#  views      :integer
#  is_private :boolean
#  author_id  :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base 
  include Votable
  include Taggable
  include ParentPost
  include Notifiable

  has_many :answers, :dependent => :destroy

  def self.tagged_with(name)
    Tag.find_by_name!(name).question
  end
end
