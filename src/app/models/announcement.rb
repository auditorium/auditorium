# == Schema Information
#
# Table name: announcements
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

class Announcement < ActiveRecord::Base 
  include Votable
  include Taggable
  include ParentPost
  include Notifiable

  def self.tagged_with(name)
    Tag.find_by_name!(name).announcement
  end

  def authors
    authors = Array.new
    authors << self.author
    authors += self.comments.map(&:author)
    authors.uniq
  end
end
