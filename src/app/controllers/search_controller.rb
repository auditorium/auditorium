class SearchController < ApplicationController
  def index
    if params[:query].present?
      query = "%#{params[:query]}%" 
      @questions = Question.where("subject LIKE ? or content LIKE ?", query, query)
      @announcements = Announcement.where("subject LIKE ? or content LIKE ?", query, query)
      @topics = Topic.where("subject LIKE ? or content LIKE ?", query, query)
      @groups = Group.where("title LIKE ? or description LIKE ?", query, query)
    end
    
    respond_to do |format|
      format.html
    end
  end
end
