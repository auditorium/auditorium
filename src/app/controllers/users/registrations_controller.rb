#app/controllers/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController

  def new
    #authorize! :create, User
    super
  end

  def create
    #authorize! :create, User
    #super
    build_resource
    #standard devise registration method corpus

    if resource.save
      # if resource.active_for_authentication?
      #   set_flash_message :notice, :signed_up if is_navigational_format?
      #   sign_in(resource_name, resource)
      #   respond_with resource, :location => after_sign_up_path_for(resource)
      # else
      #   set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      #   expire_session_data_after_sign_in!
      #   respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      # end
      if resource.email.match /tu-dresden.de$/
        redirect_to root_url, :flash => { :info => "An email with confirmation informations was sent to you."}
      else
        redirect_to root_url, :flash => { :notice => "Your account needs to be approved by the moderator. If it is approved, you'll be notified."}
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def edit
    authorize! :update, User
    super
  end

  def update
    authorize! :update, User
    faculties = Array.new
    params[:faculty_id].each do |key, id|
      if not id.empty? and not id.eql? ''
        faculty = Faculty.find(id.to_i)
        faculties << faculty if not faculties.include? faculty
      end
    end
    
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    self.resource.faculties = faculties


    if update_resource(resource_params)
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :info, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      set_flash_message :success, :updated
      respond_with resource
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update_resource(resource_params)
    if resource_params[:password].empty? 
      resource_params.delete :current_password
      resource.update_without_password(resource_params)
    else
      resource.update_with_password(resource_params)
    end
  end

end 
