module Votable
  def self.included(base)
    base.has_many :votings, as: :votable
  end

  def update_rating
    self.rating = 0
    self..votings.each do |vote|
      self.rating += vote.value
    end
    if self.save
      true
    else
      false
    end
  end
end