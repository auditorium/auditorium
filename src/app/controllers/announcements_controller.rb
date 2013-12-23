class AnnouncementsController < ApplicationController
  # load_and_authorize_resource :group
  # load_and_authorize_resource :announcement, :through => :group
  load_and_authorize_resource
  before_filter :get_group, only: ['new', 'create', 'index']

  def get_group
    @group = Group.find(params[:group_id])
  end

  def index 
    @announcements = @group.announcements.order('last_activity desc, updated_at desc').page(params[:page]).per(20) 
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
      if @announcement.save
        format.html { redirect_to @announcement, notice: t('announcements.flash.created') }
      else
        format.html { render action: 'new' }
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
        if !@announcement.author.has_badge?('editor', 'bronze')
          @announcement.author.add_badge('editor', 'bronze')
          flash[:badge] = t('badges.achieved.editor.bronze')
        end
        format.html { redirect_to announcement_path(@announcement), success:  t('announcements.flash.updated') }
      else
        format.html { render action: "edit", flash: { error: t('announcements.error.updated') } }
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
