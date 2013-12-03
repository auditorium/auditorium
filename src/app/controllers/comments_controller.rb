class CommentsController < ApplicationController

  # load_and_authorize_resource :question
  # load_and_authorize_resource :comment, :through => :commentable
  load_and_authorize_resource
  before_filter :get_commentable, only: ['new', 'create', 'index']

  def index 
    @comments = @commentable.comments.order(:created_at)
  end

  def show
    @comment = Comment.find(params[:id])
    redirect_to @comment.origin
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.author = current_user
    now = DateTime.now
    @comment.last_activity = now
    @comment.origin.last_activity = now
    @comment.origin.save

    respond_to do |format|
      if @comment.save
        format.html { redirect_to  "#{url_for @comment.origin}##{dom_id(@comment)}", notice: t('comments.flash.created') }
        format.json { render json: @comment, status: :created, location: [@commentable, @comment] }
      else
        format.html { redirect_to @comment.origin }
        format.json { render json: @comment.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    now = DateTime.now
    @comment.last_activity = now
    @comment.origin.last_activity = now
    @comment.origin.save

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.origin, flash: { success:  t('comments.flash.updated') } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: t('comments.error.updated') } }
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
  
  private

  def get_commentable
    klass = [Answer, Question, Announcement, Recording, Video, Topic].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])

    puts @commentable
  end
end
