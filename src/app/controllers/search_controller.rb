class SearchController < ApplicationController
  def index
    query = "*#{params[:query]}*"
    questions = Question.search(query, match_mode: :any).page(params[:qpage]).per(20)
    announcements = Announcement.search(query, match_mode: :any).page(params[:annpage]).per(20)
    topics = Topic.search(query, match_mode: :any).page(params[:topicpage]).per(20)
    answers = Answer.search(query, match_mode: :any).page(params[:anspage]).per(20)
    comments = Comment.search(query, match_mode: :any).page(params[:cpage]).per(20)

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
