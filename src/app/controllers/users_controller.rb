class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def moderation
  	@users = User.all
  	respond_to do |format|
  		format.html
  	end
  end

  def confirm
  	user = User.find(params[:id])
  	user.confirm!
  	user.save

    # send email to confirmed user
    AuditoriumMailer.welcome_email(user).deliver

  	if request.env['HTTP_REQUEST']
  		redirect_url = request.env['HTTP_REQUEST']
  	else
  		redirect_url = '/users/moderation'
  	end

  	respond_to do |format|
  		format.html { redirect_to redirect_url, :flash => { :success => 'The user was successfully confirmed.'}}
  	end
  end

  def destroy
    @user = User.find(params[:id])        
    @user.destroy
    redirect_to users_moderation_path, :flash => { :success => "You successfully deleted the user #{@user.full_name}!" }
    authorize! :destroy, User, :message => "You don't have authorisation to delete this user."          
  end
end
