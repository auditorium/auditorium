class TopicsController < ApplicationController

  #load_and_authorize_resource :group
  load_and_authorize_resource

  before_filter :get_group, only: ['new', 'create', 'index']

  def get_group
    @group = Group.find(params[:group_id])
  end

  def index 
    @topics = @group.topics.order('last_activity desc, updated_at desc').page(params[:page]).per(20) 
  end

  def show
    @topic = Topic.find(params[:id])

    @topic.increment_views(current_user)
  end

  def new
    @topic = @group.topics.build
  end

  def create
    @topic = @group.topics.new(params[:topic])
    @topic.author = current_user
    @topic.last_activity = DateTime.now

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: t('topics.flash.created') }
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
    @topic.last_activity = DateTime.now

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        if !@topic.author.has_badge?('editor', 'bronze')
          @topic.author.add_badge('editor', 'bronze')
        end
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
