class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    if signed_in?
      achieve_first_step_badge
      @posts = Array.new  
      cookies[:show_announcements] = params[:show_announcements] if params[:show_announcements].present?
      cookies[:show_questions] = params[:show_questions] if params[:show_questions].present?
      cookies[:show_topics] = params[:show_topics] if params[:show_topics].present?
      cookies[:only_subscribed] = params[:only_subscribed] if params[:only_subscribed].present?

      announcements = Announcement.order(last_activity: :desc, updated_at: :desc) unless cookies[:show_announcements] == 'no'
      questions = Question.order(last_activity: :desc, updated_at: :desc) unless cookies[:show_questions] == 'no'
      topics = Topic.order(last_activity: :desc, updated_at: :desc) unless cookies[:show_topics] == 'no'

      @posts += announcements if announcements.present?
      @posts += questions.delete_if { |q| cannot? :read, q } if questions.present?
      @posts += topics if topics.present?

      @posts.keep_if { |p| p.subscribed?(current_user) } if cookies[:only_subscribed] == 'yes'
      @posts = @posts.sort{ |x,y| (x.last_activity.present? and y.last_activity.present?) ? y.last_activity <=> x.last_activity : y.updated_at <=> x.updated_at }
      if params[:tags]
        cookies[:post_filter_tag_ids] = params[:tags]
        tag_ids = params[:tags].split(',').collect { |i| i.to_i }.to_set
        @posts = @posts.keep_if { |g| tag_ids.subset? g.tags.map(&:id).to_set  }
      elsif cookies[:post_filter_tag_ids]
        tag_ids = cookies[:post_filter_tag_ids].split(',').collect { |i| i.to_i }.to_set
        @posts = @posts.keep_if { |g| tag_ids.subset? g.tags.map(&:id).to_set  }
      end

      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(20)


      respond_to :js, :html
    else
      redirect_to root_url
    end
  end

  private
  def achieve_first_step_badge
    if !current_user.has_badge?('first_step', 'bronze')
      current_user.add_badge('first_step', 'bronze')
      flash[:badge] = t('badges.flash.achieved_first_step.bronze')
    end
  end
end
