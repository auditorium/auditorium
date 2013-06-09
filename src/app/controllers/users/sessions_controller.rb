class Users::SessionsController < Devise::SessionsController
  respond_to :json, :html
  
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    respond_to do |format|
      format.html do
        respond_with resource, :location => root_path
      end
      format.json do
        render :json => { :response => 'ok', :auth_token => current_user.authentication_token }.to_json, :status => :ok
      end
    end
  end

  def destroy 
    current_user.authentication_token = nil
    super
  end

  protected
  def verified_request?
    request.content_type == "application/json" || super
  end
end
