class LevelsController < ApplicationController
  def index
    @levels = Level.order('number ASC')
  end

  def show
    @level = Level.find(params[:id])
  end

  def create
    @level = Level.new(params[:level])

    if @level.save!
      redirect_to levels_path, { notice: t('levels.flash.created') }
    else
      render 'new'
    end
  end

  def edit
    @level = Level.find(params[:id])
  end

  def update
    @level = Level.find(params[:id])
    respond_to do |format|
      if @level.update_attributes(params[:level])
        format.html { redirect_to level_path(@level), {notice: t('levels.flash.updated') } } 
      else
        format.html { render 'edit' }
      end
    end
  end

  def new
    @level = Level.new
  end

  def destroy
    @level = Level.find(params[:id])
    @level.destroy
    respond_to levels_path, {notice: t('levels.flash.destroyed')}
  end
end
