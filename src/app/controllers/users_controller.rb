class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: [:index]

  def index
    if current_user.present? and current_user.experimental_group? 
      @users = User.order('score DESC').keep_if{ |u| u.confirmed? and u.list_in_leaderboard? }
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)

      respond_to :html
    else
      redirect_to home_path
    end
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
        format.html { redirect_to @user, :flash => { :success =>  t('users.flash.updated') } }
        format.json { head :no_content }
      else
        format.html { render action: "edit", :flash => { :error => t('users.error.updated') } }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @bronze_badges = Badge.where(category: 'bronze')
    @silver_badges = Badge.where(category: 'silver')
    @gold_badges = Badge.where(category: 'gold')
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
  		format.html { redirect_to redirect_url, :flash => { :success => t('users.flash.confirmed')}}
  	end
  end

  def destroy
    @user = User.find(params[:id])        
    @user.destroy
    redirect_to users_moderation_path, :flash => { :success => t('users.flash.deleted') }
    authorize! :destroy, User, :message => t('users.error.permission.delete')        
  end

  def search
    @users = User.where('username LIKE ? or first_name LIKE ? or last_name LIKE ? or email LIKE ?', "%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%").order('created_at DESC').page(params[:page]).per(20)

    respond_to do |format|
      format.js
    end
  end

  def accept_privacy_policy 
    @user = User.find(params[:id])
    @user.privacy_policy = true
    @user.username = @user.email.split('@')[0] unless @user.username.present? 
    @user.save!

    redirect_to home_path
  end
end
