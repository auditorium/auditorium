class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    if signed_in?
      @posts = Array.new  
      cookies[:show_announcements] = params[:show_announcements] if params[:show_announcements].present?
      cookies[:show_questions] = params[:show_questions] if params[:show_questions].present?
      cookies[:show_topics] = params[:show_topics] if params[:show_topics].present?
      cookies[:only_subscribed] = params[:only_subscribed] if params[:only_subscribed].present?

      announcements = Announcement.all unless cookies[:show_announcements] == 'no'
      questions = Question.all unless cookies[:show_questions] == 'no'
      topics = Topic.all unless cookies[:show_topics] == 'no'

      @posts += announcements if announcements.present?
      @posts += questions.delete_if { |q| cannot? :read, q } if questions.present?
      @posts += topics if topics.present?
      @posts = @posts.sort { |x,y| y.created_at <=> x.created_at }

      

      @posts.keep_if { |p| p.subscribed?(current_user) } if cookies[:only_subscribed] == 'yes'

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
end
