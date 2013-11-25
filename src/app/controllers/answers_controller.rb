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
    redirect_to @answer.origin
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(params[:answer])
    @answer.author = current_user
    now = DateTime.now
    @answer.origin.last_activity = now
    @answer.origin.save!
    @answer.last_activity = now

    respond_to do |format|
      if @answer.save!
        format.html { redirect_to question_path(@answer.question), notice: t('answers.flash.created') }
        format.json { render json: @answer, status: :created, location: [@question, @answer] }
      else
        format.html { render action: 'new' }
        format.json { render json: @answer.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    
    now = DateTime.now
    @answer.last_activity = now
    @answer.origin.last_activity = now
    @answer.origin.save!

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to answer_path(@answer), flash: { success:  'answer was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "answer couldn't be updated!" } }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_as_helpful
    @answer = Answer.find(params[:id])
    if @answer.answer_to_id.nil?
      @answer.answer_to_id = @answer.question.id
    else
      @answer.answer_to_id = nil
    end
    @answer.save!

    respond_to do |format|
      format.js
      format.html {redirect_to question_path(@answer.question, anchor: dom_id(@answer)) }
    end
  end

end
