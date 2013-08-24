class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index

    @posts = Array.new  

    announcements = Announcement.all unless params[:show_announcements] == 'no'
    questions = Question.all unless params[:show_questions] == 'no'
    topics = Topic.all unless params[:show_topics] == 'no'

    @posts += announcements if announcements.presence
    @posts += questions if questions.presence
    @posts += topics if topics.presence
    @posts = @posts.sort { |x,y| y.created_at <=> x.created_at }
  end
end
