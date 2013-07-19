class TagsController < ApplicationController
  def index
    @tags = Tag.order(:name)
    respond_to do |format|
      format.json { render json: @tags.tokens(params[:q]) }
    end 
  end
end
