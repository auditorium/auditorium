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
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(params[:answer])
    @answer.author = current_user

    respond_to do |format|
      if @answer.save!
        format.html { redirect_to question_path(@answer.question), notice: t('answer.action.created') }
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

end
