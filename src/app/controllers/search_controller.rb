class SearchController < ApplicationController
  def index
    lectures = Lecture.search(params[:query], match_mode: :any)
    courses = Course.search(params[:query], match_mode: :any)
    
    posts = Post.search params[:query], match_mode: :any

    @results = {:posts => posts, :courses => courses, :lectures => lectures}
    respond_to do |format|
      format.js
      format.html
    end
  end
end
