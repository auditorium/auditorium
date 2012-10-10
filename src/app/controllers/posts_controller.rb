class PostsController < ApplicationController
  load_and_authorize_resource

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('created_at DESC').where('post_type = ? or post_type = ?', 'question', 'info').all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.is_private = params[:is_private] if params[:is_private]
    @post.subject = params[:subject] if params[:subject]
    @post.body = params[:body] if params[:body]

    if params[:course_id]
      @post.course_id = params[:course_id]
      @course_name = Course.find(params[:course_id]).name
    end 
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def maintainer_request
    @post = Post.new
    @post.post_type = 'question'
    @post.is_private = true
    @post.subject = "Bitte authorisiere mich als Maintainer des Kurses."
    @post.body = "Hallo,\nbitte authorisiert mich als Maintainer des Kurses.\nVielen Dank\n#{current_user.full_name}"

    if params[:course_id]
      @post.course_id = params[:course_id]
      @course_name = Course.find(params[:course_id]).name
    end 
    
    respond_to do |format|
      format.html
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.author = current_user
    @post.last_activity = DateTime.now
    @post.is_private = true if @post.origin.is_private?

    respond_to do |format|
      if @post.save
        format.js
        format.html { redirect_to post_path(@post.origin, :anchor => "post-#{@post.id}"), :flash => { :success => 'Post was successfully created.' } }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.js
        format.html { render action: 'new', :flash => { :error => "Post couldn't be created!"} }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @post.last_activity = @post.updated_at


    @origin = @post
    @origin = @post.parent_id if @post.parent_id
    @post.origin.last_activity = DateTime.now
    @post.origin.save

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to post_url(@post.origin, :anchor => "post-#{@post.id}"), :flash => { :success =>  'Post was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", :flash => { :error => "Post couldn't be updated!" } }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    if @post.origin
      origin_path = root_path
    else
      origin_path = @post.parent if @post.parent
      origin_path = @post.parent.parent if @post.parent and @post.parent.parent
    end

    reports = Report.find_all_by_post_id(@post.id)
    Report.destroy(reports)

    notifications = Notification.where(:notifyable_id => @post.id, :notifyable_type => 'Post')
    notifications.each do |n|
      n.destroy
    end

    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_path, flash: { success: 'The post was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  def answered 

    @answer = Post.find(params[:id])
    @parent = @answer.parent

    if @answer.answer_to_id.nil?
      @answer.answer_to_id = @parent.id
    else
      @answer.answer_to_id = nil
    end

    @answer.save

    respond_to do |format|
      if @answer.answer_to_id.nil?
        format.js 
        format.html { redirect_to @parent, :flash => { :success => "Oh. That's bad, that it is no answer." } }
      else
        format.js 
        format.html { redirect_to @parent, :flash => { :success => 'Great that this answer helped you!' } }
      end
    end
  end
  
  #custom methods for answering and commenting
  def answering
    @parent = Post.find(params[:parent_id])
    body = params[:body]
    subject = body[0..20]
    @post = Post.new(:subject => subject,
                     :body => params[:body], 
                     :parent_id => params[:parent_id], 
                     :course_id => @parent.course_id,
                     :author_id => current_user.id,
                     :post_type => 'answer')

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post.origin, :anchor => "post-#{@post.id}"), :flash => { :success => "Thanks for your answer." } }
        format.json { render json: @post.parent }
      else 
        format.html { redirect_to redirect_url, :flash => { :error => "Something went wrong. Please try again." } }
        format.json { render json: @post.parent.errors, status: :unprocessable_entity }
      end
    end
  end

  def commenting

    @parent = Post.find(params[:parent_id])
    if @parent.parent_id
      @origin_post = Post.find(@parent.parent_id) 
    else
      @origin_post = @parent
    end
    
    body = params[:body]
    subject = body[0..20]
    @comment = Post.new(:subject => subject,
                     :body => body, 
                     :parent_id => params[:parent_id], 
                     :answer_to_id => nil, 
                     :course_id => @parent.course_id,
                     :author_id => current_user.id,
                     :post_type => 'comment')

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_url(@comment.origin, :anchor => "post-#{@comment.id}"), :flash => { :success => "Your comment was successfully submitted." } }
        format.json { render json: @origin_post }
      else 
        format.html { redirect_to post_path(@origin_post), :flash => { :error => "Something went wrong with your comment. Please try again." } }
        format.json { render json: @origin_post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def rate
    @post = Post.find(params[:id])
    @rating_by_user = Rating.find_by_user_id_and_post_id(current_user.id, @post.id)
    already_voted = false
    
    if request.env["HTTP_REFERER"]
      redirect_url = request.env["HTTP_REFERER"]
    else
      redirect_url = @post
    end
    
    if params['up']
      if @rating_by_user.nil?
        Rating.create(:user_id => current_user.id, :post_id => @post.id, :points => 1)
        @post.rating += 1
        @post.save
      elsif not @rating_by_user.nil? and @rating_by_user.points < 1
        @rating_by_user.points += 1
        @rating_by_user.save
        @post.rating += 1
        @post.save
      else
        already_voted = true
      end
    elsif params['down']
      if @rating_by_user.nil?
        Rating.create(:user_id => current_user.id, :post_id => @post.id, :points => -1)
        @post.rating -= 1
        @post.save
      elsif not @rating_by_user.nil? and @rating_by_user.points > -1
        @rating_by_user.points -= 1
        @rating_by_user.save
        @post.rating -= 1
        @post.save
      else
        already_voted = true
      end
    end

    respond_to do |format|
      if not already_voted
        format.js 
        format.html { redirect_to redirect_url, :flash => { :success => 'Dein Rating wurde erfolgreich abgegeben!' } }
        format.json { render json: @post, status: :following, location: redirect_url }
      else
        
        format.js 
        format.html { redirect_to redirect_url, :flash => { :error => 'Du hast den Post bereits bewertet!' } }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end



end
