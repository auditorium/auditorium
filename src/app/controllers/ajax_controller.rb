class AjaxController < ApplicationController

  def preview
    @preview = { subject: params[:subject], content: params[:content], type: params[:post_type]}

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

    
    @message = t('votes.flash.not_saved')

    ActiveRecord::Base.transaction do 
      @message = @post.upvote(current_user)
    
      respond_to do |format|
        if @post.update_rating
          achieve_post_badge(current_user, @post)
          achieve_rewarding_badge(current_user)

          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: @message }
        else 
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('votes.flash.problem_voting') }
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
    
    @message = t('votes.flash.not_saved')
    
    ActiveRecord::Base.transaction do 
      @message = @post.downvote(current_user)
      

      respond_to do |format|
        if @post.update_rating
          achieve_critical_badge(current_user)
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: @message }
        else 
          format.js
          format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('votes.flash.problem_voting') }
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
    @element_id = params[:element_id]
    respond_to :js
  end

  def save_tutorial_progress
    if current_user.present?
      name = params[:tutorial_name]
      tutorial_progress = TutorialProgress.find_or_initialize_by_user_id(current_user.id)
      case name
      when 'intro'
        tutorial_progress.introduction = true  
      when 'groups'
        tutorial_progress.groups = true
      when 'group'
        tutorial_progress.group = true
      when 'question'
        tutorial_progress.question = true
      end

      tutorial_progress.save

      achieve_curious_badge(current_user, tutorial_progress)

      
    end
    respond_to :js
  end

end
