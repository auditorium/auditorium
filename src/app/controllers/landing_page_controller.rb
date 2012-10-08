class LandingPageController < ApplicationController
  def index
  	if current_user
  		respond_to do |format|
  			format.html { redirect_to home_path, :info => "Sorry, you don't have permissions for this action."}
  		end
  	end
  end
end
