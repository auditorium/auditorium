class SettingsController < ApplicationController

  
  def create
    puts "USER_ID: #{params[:user_id]}"
    user = User.find(params[:user_id])
    @setting = Setting.new(params[:setting])
    @setting.user = user

    if @setting.save!
      respond_to :js
    end
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes!(params[:setting]) 
     respond_to :js
    end
  end
end
