class LandingPageController < ApplicationController
  layout "landing_page"
  def index
  	if current_user
  		respond_to do |format|
  			format.html { redirect_to home_path, :warning => t('flash.permission_denied')}
  		end
  	end
  end
end
