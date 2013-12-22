class AnswersController < ApplicationController

  # load_and_authorize_resource :question
  # load_and_authorize_resource :answer, :through => :question
  load_and_authorize_resource
  before_filter :get_question, only: ['new', 'create', 'index']

  def get_question
    @question = Question.find(params[:question_id])
  end

  def index 
    @questions = @question.answers.order(:created_at)
  end

  def show
    @answer = Answer.find(params[:id])
    redirect_to question_path(@answer.origin, anchor: dom_id(@answer))
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(params[:answer])
    @answer.author = current_user
    now = DateTime.now
    @answer.origin.last_activity = now
    @answer.origin.save
    @answer.last_activity = now

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_path(@answer.question), notice: t('answers.flash.created') }
      else
        format.html { render action: 'new' }
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
    @answer.origin.save

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        if !@answer.author.has_badge?('editor', 'bronze')
          @answer.author.add_badge('editor', 'bronze')
        end
        format.html { redirect_to question_path(@answer.question), flash: { success:  t('answers.flash.updated') } }
      else
        format.html { render action: "edit", flash: { error: t('answers.error.updated') } }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    path = @answer.origin
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to path, notice: t('answers.flash.destroyed')}
    end
  end

  def toggle_as_helpful
    @answer = Answer.find(params[:id])
    if @answer.answer_to_id.nil?
      @answer.answer_to_id = @answer.question.id
    else
      @answer.answer_to_id = nil
    end
    @answer.save

    respond_to do |format|
      format.js
      format.html {redirect_to question_path(@answer.question, anchor: dom_id(@answer)) }
    end
  end

end
