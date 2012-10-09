class SearchController < ApplicationController
  def index
    query = "*#{params[:query]}*"
    lectures = Lecture.search(query, match_mode: :any).page(params[:lecture_page]).per(20)
    courses = Course.search(query, match_mode: :any).page(params[:course_page]).per(20)
    
    posts = Post.search query, match_mode: :any
    posts.keep_if{|p| can? :read, p.origin}

    Kaminari.paginate_array(posts).page(params[:post_page]).per(20)

    @results = {:posts => posts, :courses => courses, :lectures => lectures}

    respond_to do |format|
      format.js
      format.html
    end
  end
end
