class PostsController < ApplicationController
  load_and_authorize_resource
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('created_at DESC').where('post_type = ? or post_type = ?', 'question', 'info').all
    
    @posts_per_day = @posts.group_by{ |post| post.created_at.to_date.beginning_of_day }

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
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
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
    
      
      
    respond_to do |format|
      if @post.save
        # create tags for this post
        tags = params[:tags].split(/[^a-zA-Z0-9\-#\+\.]+/)
        tags.each do |tag|
          Tag.create(:name => tag, :post => @post)
        end
        format.js
        format.html { redirect_to @post.course, :flash => { :success => 'Post was successfully created.' } }
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
    @origin = @post
    @origin = @post.parent_id if @post.parent_id

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to post_path(@origin), :flash => { :success =>  'Post was successfully updated.' } }
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
    
    @origin = root_path
    @origin = @post.parent if @post.parent
    @origin = @post.parent.parent if @post.parent and @post.parent.parent
    
    notifications = Notification.where(:notifyable_id => @post.id, :notifyable_type => 'Post')
    Notification.destroy(notifications)
    @post.destroy

    respond_to do |format|
      format.html { redirect_to @origin or root_path if @origin_post.nil? }
      format.json { head :no_content }
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
                     :answer_to_id => params[:parent_id], 
                     :course_id => @parent.course_id,
                     :author_id => current_user.id,
                     :post_type => 'answer')

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post.parent, :flash => { :success => "Thanks for your answer." } }
        format.json { render json: @post.parent }
      else 
        format.html { redirect_to redirect_url, :flash => { :error => "It went something wrong. Please try again to answer this post." } }
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
        format.html { redirect_to post_path(@origin_post), :flash => { :success => "Dein Kommentar wurde erfolgreich abgegeben." } }
        format.json { render json: @origin_post }
      else 
        format.html { redirect_to post_path(@origin_post), :flash => { :error => "Dein Kommentar konnte nicht eingetragen werden..." } }
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
