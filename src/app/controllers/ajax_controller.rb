class AjaxController < ApplicationController
  def courses
  	if params[:term]
      like= "%".concat(params[:term].concat("%"))
      courses = Course.where("name like ?", like).limit(10)
    else
      courses = Course.all(limit: 10)
    end
    list = courses.map {|c| Hash[ id: c.id, label: (c.name_with_term short: false), name: (c.name_with_term short: false)]}
    render json: list
  end

  def lectures
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      lectures = Lecture.where("name like ?", like).limit(10)
    else
      lectures = Lecture.all(limit: 10)
    end
    list = lectures.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def chairs
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      chairs = Chair.where("name like ?", like).limit(10)
    else
      chairs = Chair.all(limit: 10)
    end
    list = chairs.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def preview
    @preview = { subject: params[:subject], content: params[:content], type: params[:post_type]}

    respond_to :js
  end

  def load_form 
    @form_type = params[:form_type]
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
    @post.rating = 0 if @post.rating.nil?
    @post.rating += 1
    @post.save

    respond_to do |format|
      format.js
      format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", error: @post.errors }
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
    
    puts "POST: #{@post}"
    @post.rating = 0 if @post.rating.nil?
    @post.rating -= 1
    @post.save

    respond_to do |format|
      format.js
      format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('posts.general.upvote.notice') }
    end
  end

end
