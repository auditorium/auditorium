class CommentsController < ApplicationController

  # load_and_authorize_resource :question
  # load_and_authorize_resource :answer, :through => :question
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
        format.html { redirect_to @comment.commentable, notice: t('answer.action.created') }
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
      if @commentable.update_attributes(params[:answer])
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
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.commentable, notice: t('answers.flash.destroyed') }
      format.json { head :no_content }
    end
  end

  def upvote 
    @comment = Comment.find(params[:id])
    @comment.rating += 1
    @comment.save

    respond_to do |format|
      format.html { redirect_to @comment.commentable, notice: t('posts.general.upvote.notice') }
      format.json { head :no_content }
    end
  end

  def downvote 
    @comment = Comment.find(params[:id])
    @comment.rating -= 1
    @comment.save

    respond_to do |format|
      format.html { redirect_to @comment.commentable, notice: t('posts.general.downvote.notice') }
      format.json { head :no_content }
    end
  end


  private

  def get_commentable
    klass = [Answer, Question, Announcement, Recording].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])

    puts @commentable
  end
end
