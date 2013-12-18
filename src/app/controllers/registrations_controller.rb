class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  layout 'landing_page', only: [:new, :create]
  # GET /resource/sign_up
  def new
    build_resource({})
    respond_with self.resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      # if resource.active_for_authentication?
      #   set_flash_message :notice, :signed_up if is_navigational_format?
      #   sign_up(resource_name, resource)
      #   respond_with resource, :location => after_sign_up_path_for(resource)
      # else
      #   set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      #   expire_session_data_after_sign_in!
      #   respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      # end

      if resource.email.match /tu-dresden.de$/
        redirect_to root_url, :flash => { :info => t('general.flash.confirmation_sent')}
      else
        redirect_to root_url, :flash => { :notice => t('general.flash.moderation_needed')}
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  # custom methods for user profile
  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present?
  end
end

