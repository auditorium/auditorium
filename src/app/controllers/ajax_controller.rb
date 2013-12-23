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
      achieve_rewarding_badge(current_user, 'bronze')

      respond_to do |format|
        if @post.update_rating
          achieve_post_badge(@post, 'bronze', 1)
          achieve_post_badge(@post, 'silver', 5)
          achieve_post_badge(@post, 'gold', 10)

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
      achieve_critical_badge(current_user, 'bronze')

      respond_to do |format|
        if @post.update_rating
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
    if tutorial_progress.percentage == 100 and !current_user.has_badge?('curious', 'silver')
      current_user.add_badge('curious', 'silver')
      flash[:badge] = t('badges.flash.achieve_curious.silver')
    end
    respond_to :js
  end

  private
  def achieve_rewarding_badge(user, category)
    if !user.has_badge?('rewarding', category)
      user.add_badge('rewarding', category)
      flash[:badge] = "EARNED rewarding BADGE"
    end
  end

  def achieve_critical_badge(user, category)
    if !user.has_badge?('critical', category)
      user.add_badge('critical', category)
    end
  end

  # ======== GAMIFICATION
  def achieve_post_badge(post, category, threshold)
    puts "======> CLASS: #{post.class.name}"
    case post.class.name
    when 'Question'
      title = 'learning'
    when 'Answer'
      title = 'cooperative'
    when 'Announcement'
      title = 'significant'
    when 'Topic'
      title = 'something_to_say'
    when 'Comment'
      title = 'commenter'
    end

    if !post.author.has_badge?(title, category) and post.rating >= threshold  
      post.author.add_badge(title, category)
      post.author.save
      flash[:badge] = t("badges.flash.achieve_#{title}.#{category}")
    end
  end
end
