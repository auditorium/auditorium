class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :create_user
  before_filter :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    unless current_user
      authenticate_user!
    else
      redirect_to home_path, {:exception => exception, :notice => "Sorry, you don't have permissions to access this page." }
    end
  end

  # redirect admin users
  def authenticate_admin_user! #use predefined method name
    redirect_to '/' and return if user_signed_in? && !current_user.is_admin? 
    authenticate_user! 
  end 
  def current_admin_user #use predefined method name
    return nil if user_signed_in? && !current_user.is_admin? 
    current_user 
  end 

  # possible values for params: email, password, first_name, last_name, display_name, person_identifier
  def create_user params, send_info_email = false
    if params[:email] && !params[:email].empty?
      email = params[:email].downcase
    else
      email = params[:person_identifier] + '@example.com' if params[:person_identifier]
    end

    if email && email =~ /\A[^@]+@[^@]+\z/
      u = User.find_by_email(email)
      email_correct = true
    end
    return u if u

    # no existing user, create new
    u = User.new
    u.email = email

    unless email_correct 
      while User.find_by_email(u.email)
        if params[:first_name] && !params[:first_name].empty? && params[:last_name] && !params[:last_name].empty?
          identifier = params[:first_name] + '.' + params[:last_name] + SecureRandom.hex(5)
        else
          identifier = SecureRandom.hex(15)
        end
        u.email = identifier + '@example.com'
      end
    end

    if params[:password] && !params[:password].empty?
      pw = params[:password]
    else
      pw = SecureRandom.base64(5)
    end
    u.password = pw
    u.password_confirmation = pw

    u.first_name = params[:first_name]
    u.last_name = params[:last_name]
    if params[:display_name]
      u.display_name = params
    elsif u.first_name && u.last_name
      u.display_name = u.first_name + ' ' + u.last_name
    end

    u.skip_confirmation! if User.respond_to? 'skip_confirmation!' # skip the confirmation email, that would be automatically sent by devise
    AuditoriumMailer.automatically_generated_user(u.email, password).deliver if send_info_email unless u.email.include? '@example.com'

    u.save
    u
  end

  def url_options
    super
    @_url_options.dup.tap do |options|
      options[:protocol] = Rails.env.production? ? "https://" : "http://"
      options.freeze
    end
  end

  private
  def set_current_user
    User.current = current_user
  end

  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    
    url = session.delete("#{scope}_return_to")

    "#{url}#{params[:url_hash]}" if params[:url_hash]
    
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  end
end
