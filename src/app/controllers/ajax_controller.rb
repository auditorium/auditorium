class AjaxController < ApplicationController

  def preview
    @preview = { subject: params[:subject], content: params[:content], type: params[:post_type]}

    respond_to :js
  end

  def load_post_form 
    @form_type = params[:form_type]
    respond_to :js
  end

  def search
    unless params[:query].empty?
      query = "%#{params[:query]}%" 
      @questions = Question.where("subject LIKE ? or content LIKE ?", query, query)
      @announcements = Announcement.where("subject LIKE ? or content LIKE ?", query, query)
      @topics = Topic.where("subject LIKE ? or content LIKE ?", query, query)
      @groups = Group.where("title LIKE ? or description LIKE ?", query, query)
    end
    
    respond_to :js, :html
  end

  def upvote 
    case params[:type]
      when 'comments' then @post = Comment.find(params[:id])
      when 'answers' then @post = Answer.find(params[:id])
      when 'questions' then @post = Question.find(params[:id])
      when 'announcements' then @post = Announcement.find(params[:id])
      when 'topics' then @post = Topic.find(params[:id])
      when 'videos' then @post = Video.find(params[:id])
      else @post = nil
    end

    
    @message = t('votes.not_saved')

    ActiveRecord::Base.transaction do 
      vote_attributes = { votable_id: @post.id, votable_type: @post.class.name }
      @vote = current_user.votings.where(vote_attributes).first
      @vote = current_user.votings.build(vote_attributes) unless @vote.presence

      case @vote.value 
      when -1, 0, nil
        @vote.value = 0 if @vote.value.nil?
        @vote.value += 1
        @message = t('votes.successfully_upvoted')
        @vote.save
      else
        @message = t('votes.already_upvoted')
      end

      respond_to do |format|
        if @post.update_rating
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: @message }
        else 
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('votes.problem_voting') }
        end
      end
    end
  end

  def downvote 
    case params[:type]
      when 'comments' then @post = Comment.find(params[:id])
      when 'answers' then @post = Answer.find(params[:id])
      when 'questions' then @post = Question.find(params[:id])
      when 'announcements' then @post = Announcement.find(params[:id])
      when 'topics' then @post = Topic.find(params[:id])
      when 'videos' then @post = Video.find(params[:id])
      else @post = nil
    end
    
    @message = t('votes.not_saved')
    
    ActiveRecord::Base.transaction do 
      vote_attributes = { votable_id: @post.id, votable_type: @post.class.name }
      @vote = current_user.votings.where(vote_attributes).first
      @vote = current_user.votings.build(vote_attributes) unless @vote

      case @vote.value 
      when 0, 1, nil
        @vote.value = 0 if @vote.value.nil? 
        @vote.value -= 1
        @message = t('votes.successfully_downvoted')
        @vote.save!
      else
        @message = t('votes.already_downvoted')
      end    

    

      respond_to do |format|
        if @post.update_rating
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: @message }
        else 
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('votes.problem_voting') }
        end
      end

    end
  end

  def tab_content 
    view = params[:view]
    @user = User.find(params[:user_id])

    @partial = "users/#{view}"

    if view.eql? 'settings'
      @setting = @user.setting.nil? ? Setting.new(user_id: @user.id) : @user.setting
    end
    

    respond_to do |format|
      format.js
    end
  end

  def load_markdown_sheet
    respond_to :js
  end

end
