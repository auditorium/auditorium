class VideosController < ApplicationController
  # load_and_authorize_resource :group
  # load_and_authorize_resource :video, :through => :group
  before_filter :get_group, only: ['new', 'create', 'index']

  # def index 
  #   @videos = @group.videos.order(:created_at)
  # end

  def show
    @video = Video.find(params[:id])
  end

  def new
    @video = @group.videos.build
  end

  def create
    @video = @group.videos.new(params[:video])
    @video.author = current_user

    respond_to do |format|
      if @video.save!
        format.html { redirect_to @video, notice: t('videos.flash.created') }
        format.json { render json: @video, status: :created, location: [@group, @video] }
      else
        format.html { render action: 'new' }
        format.json { render json: @video.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to video_path(@video), flash: { success:  'video was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "video couldn't be updated!" } }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @group = @video.group
    @video.destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: t('videos.flash.destroyed') }
      format.json { head :no_content }
    end
  end

  def preview
    @post = { subject: params[:subject], content: params[:content]}

    respond_to do |format|
      format.js
    end
  end

  private 
  def get_group
    @group = Group.find(params[:group_id])
  end

end
