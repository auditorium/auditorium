class SearchController < ApplicationController
  def index
    query = "*#{params[:query]}*"
    lectures = Lecture.search(query, match_mode: :any)
    courses = Course.search(query, match_mode: :any)
    
    posts = Post.search query, match_mode: :any
    posts.keep_if{|p| can? :read, p}

    @results = {:posts => posts, :courses => courses, :lectures => lectures}
    respond_to do |format|
      format.js
      format.html
    end
  end
end
