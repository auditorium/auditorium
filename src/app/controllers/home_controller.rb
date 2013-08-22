class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    @groups = Group.order(:title)
  end
end
