class Media < ActiveRecord::Base
  belongs_to :author
  belongs_to :group
  attr_accessible :content, :private, :subject, :url, :views
end
