class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    if signed_in?
      @posts = Array.new  

      announcements = Announcement.all unless params[:show_announcements] == 'no'
      questions = Question.all unless params[:show_questions] == 'no'
      topics = Topic.all unless params[:show_topics] == 'no'



      @posts += announcements if announcements.present?
      @posts += questions if questions.present?
      @posts += topics if topics.present?
      @posts = @posts.sort { |x,y| y.created_at <=> x.created_at }

      @posts.keep_if { |p| p.subscribed?(current_user) } if params[:only_subscribed] == 'yes'

      respond_to :html #, :js
    else
      redirect_to root_url
    end
  end
end
