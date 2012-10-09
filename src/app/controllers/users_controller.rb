class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    unless @user.admin?
      @user.admin = params[:admin]
      AuditoriumMailer.user_becomes_admin(@user).deliver  
    end 
    
    respond_to do |format|
      if @user.update_without_password(params[:user])
        format.html { redirect_to @user, :flash => { :success =>  'User was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", :flash => { :error => "User couldn't be updated!" } }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end  
  end

  def moderation
  	@users = User.order('created_at DESC').page(params[:page]).per(20)
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

  def search
    @users = User.where('username LIKE ? or first_name LIKE ? or last_name LIKE ? or email LIKE ?', "%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%").order('created_at DESC').page(params[:page]).per(20)

    respond_to do |format|
      format.js
    end
  end
end
