class TopicsController < ApplicationController
  # load_and_authorize_resource :group
  # load_and_authorize_resource :announcement, :through => :group
  before_filter :get_group, only: ['new', 'create', 'index']

  def get_group
    @group = Group.find(params[:group_id])
  end

  def index 
    @topics = @group.topics.order(:created_at)
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = @group.topics.build
  end

  def create
    @topic = @group.topics.new(params[:topic])
    @topic.author = current_user

    respond_to do |format|
      if @topic.save!
        format.html { redirect_to @topic, notice: t('topic.action.created') }
        format.json { render json: @topic, status: :created, location: [@group, @topic] }
      else
        format.html { render action: 'new' }
        format.json { render json: @topic.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to topic_path(@topic), flash: { success:  'topic was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "topic couldn't be updated!" } }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @group = @topic.group
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: t('topics.flash.destroyed') }
      format.json { head :no_content }
    end
  end

end
