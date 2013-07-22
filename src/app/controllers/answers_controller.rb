class AnswersController < ApplicationController

  # load_and_authorize_resource :question
  # load_and_authorize_resource :answer, :through => :question
  before_filter :get_question, only: ['new', 'create', 'index']

  def get_question
    @question = Question.find(params[:question_id])
  end

  def index 
    @questions = @question.answers.order(:created_at)
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = @question.answers.build(post_type: 'answer')
  end

  def create
    @answer = @question.answers.new(params[:answer])
    @answer.question = @question
    @answer.post_type = 'answer'
    @answer.author = current_user

    respond_to do |format|
      if @answer.save!
        format.html { redirect_to @answer, notice: t('answer.action.created') }
        format.json { render json: @answer, status: :created, location: [@question, @answer] }
      else
        format.html { render action: 'new' }
        format.json { render json: @answer.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @answer = Question.find(params[:id])
  end

  def update
    @answer = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:answer])
        format.html { redirect_to @answer, flash: { success:  'Answer was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "Answer couldn't be updated!" } }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to @question, notice: t('answers.flash.destroyed') }
      format.json { head :no_content }
    end
  end
end
