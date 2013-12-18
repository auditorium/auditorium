class BadgesController < ApplicationController
  def index
    @badges = Badge.order('title DESC')
  end

  def new
    @badge = Badge.new()
  end

  def create
    @badge = Badge.new(params[:badge])

    respond_to do |format|
      if @badge.save
        format.html { redirect_to badges_path, {notice: t('badges.flash.updated') } } 
      else
        format.html { render 'new' }
      end
    end
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def update
    @badge = Badge.find(params[:id])
    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        format.html { redirect_to badges_path, {notice: t('badges.flash.updated') } } 
      else
        format.html { render 'new' }
      end
    end
  end

  def destroy
    @badge = Badge.find(params[:id])
    @badge.destroy

    redirect_to badges_path, notice: t('badges.error.destroyed')

  end

end
