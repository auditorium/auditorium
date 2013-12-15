module Votable
  def self.included(base)
    base.has_many :votings, as: :votable
  end

  def upvote(current_user)
    vote_attributes = { votable_id: self.id, votable_type: self.class.name }
    @vote = current_user.votings.where(vote_attributes).first
    @vote = current_user.votings.build(vote_attributes) unless @vote.presence

    case @vote.value 
    when -1, 0, nil
      @vote.value = 0 if @vote.value.nil?
      @vote.value += 1

      # update reputation for user
      self.author.score += 5
      self.author.save

      if @vote.value == 0
        current_user.score += 1
        current_user.save
      end
      
      @message = I18n.t('votes.flash.successfully_upvoted')
      @vote.save
    else
      @message = I18n.t('votes.flash.already_upvoted')
    end
    @message
  end

  def downvote(current_user)
    vote_attributes = { votable_id: self.id, votable_type: self.class.name }
    @vote = current_user.votings.where(vote_attributes).first
    @vote = current_user.votings.build(vote_attributes) unless @vote
    case @vote.value 
    when 0, 1, nil
      @vote.value = 0 if @vote.value.nil? 
      @vote.value -= 1
      self.author.score -= 5
      self.author.save
      if @vote.value == -1
        current_user.score -= 1
        current_user.save
      end
      @message = I18n.t('votes.flash.successfully_downvoted')
      @vote.save
    else
      @message = I18n.t('votes.flash.already_downvoted')
    end   
    @message 
  end

  def update_rating
    self.rating = 0
    puts "VOTINGS: #{self.votings.map(&:value)}"
    self.votings.each do |vote|
      self.rating += vote.value
    end
    self.save
  end
end