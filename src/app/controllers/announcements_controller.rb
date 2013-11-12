class AnnouncementsController < ApplicationController
  # load_and_authorize_resource :group
  # load_and_authorize_resource :announcement, :through => :group
  before_filter :get_group, only: ['new', 'create', 'index']

  def get_group
    @group = Group.find(params[:group_id])
  end

  def index 
    @announcements = @group.announcements.order(:created_at)
  end

  def show
    @announcement = Announcement.find(params[:id])
    @announcement.increment_views(current_user)
  end

  def new
    @announcement = @group.announcements.build
  end

  def create
    @announcement = @group.announcements.new(params[:announcement])
    @announcement.author = current_user
    @announcement.last_activity = DateTime.now

    respond_to do |format|
      if @announcement.save!
        format.html { redirect_to @announcement, notice: t('announcement.action.created') }
        format.json { render json: @announcement, status: :created, location: [@group, @announcement] }
      else
        format.html { render action: 'new' }
        format.json { render json: @announcement.errors, status: :unprecessable_entity }
      end
    end
  end

  def edit 
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])
    @announcement.last_activity = DateTime.now

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to announcement_path(@announcement), flash: { success:  'announcement was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", flash: { error: "announcement couldn't be updated!" } }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @group = @announcement.group
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: t('announcements.flash.destroyed') }
      format.json { head :no_content }
    end
  end

  def preview
    @post = { subject: params[:subject], content: params[:content]}

    respond_to do |format|
      format.js
    end
  end

end
