class CommentsController < ApplicationController

  # load_and_authorize_resource :question
  # load_and_authorize_resource :comment, :through => :commentable
  before_filter :get_commentable, only: ['new', 'create', 'index']

  def index 
    @comments = @commentable.comments.order(:created_at)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.author = current_user

    respond_to do |format|
      if @comment.save!
        redirect_path =  
        format.html { redirect_to  "#{url_for @comment.origin}##{dom_id(@comment)}", notice: t('comment.action.created') }
        format.json { render json: @comment, status: :created, location: [@commentable, @comment] }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @commentable.update_attributes(params[:comment])
        format.html { redirect_to @comment, flash: { success:  'Comment was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "Comment couldn't be updated!" } }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    origin = @comment.origin
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to url_for(origin), notice: t('comments.flash.destroyed') }
      format.json { head :no_content }
    end
  end

  def upvote 
    @post = Comment.find(params[:id])
    @post.rating += 1
    @post.save

    respond_to do |format|
      format.js
      #format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", error: @post.errors }
    end

  end

  def downvote 
    @post = Comment.find(params[:id])
    
    @post.rating -= 1
    @post.save

    respond_to do |format|
      format.js
      #format.html { redirect_to "#{url_for @post.origin}##{dom_id(@post)}", notice: t('posts.general.upvote.notice') }
    end
  end
  
  private

  def get_commentable
    klass = [Answer, Question, Announcement, Recording].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])

    puts @commentable
  end
end
