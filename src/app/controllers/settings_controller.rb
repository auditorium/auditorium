class SettingsController < ApplicationController

  load_and_authorize_resource
  def create
    puts "USER_ID: #{params[:user_id]}"
    @user = User.find(params[:user_id])
    @setting = Setting.new(params[:setting])
    unless @setting.persisted?
      @setting.user_id = @user.id
      @setting.save
    end
    respond_to :js
  end

  def update
    @setting = Setting.find(params[:id])
    @user = User.find(params[:user_id])
    if @setting.update_attributes!(params[:setting]) 
     respond_to :js
    end
  end

  def groups
    @user = User.find(params[:user_id])
    @setting = @user.setting

    @user.followings.each do |following|
      if following.followerable_type.eql? 'Group'
        following.receive_notifications = params["receive_notifications"]["group_#{following.followerable_id}"].present? ? true : false
        following.save
      end
    end
    # params["receive_notifications"].each do |key, value|
    #   group_id = key.split('_')[1].to_i
    #   following = @user.followings.find_by_followerable_id_and_followerable_type(group_id, Group)
    #   following.receive_notifications = (value.to_i == 1 ? true : false)
    #   following.save
    # end
    respond_to :js
  end
end
