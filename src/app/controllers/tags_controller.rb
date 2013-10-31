class TagsController < ApplicationController
  def index
    @tags = Tag.order(:name)
    filter = (params[:controller].eql? 'groups' and params[:action].eql? 'index') or params[:my_groups]
    respond_to do |format|
      format.json { render json: @tags.tokens({query: params[:q], filter: filter}) }
    end 
  end
end
