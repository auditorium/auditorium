class Tag < ActiveRecord::Base
  belongs_to :post
  attr_accessible :name, :post

  validates :name,  presence: true
  validates :post, presence: true

  define_index do
    indexes name
  end
end
