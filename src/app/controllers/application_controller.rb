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

  # used for dynamic error pages
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404 # To prevent Rails 3.2.8 deprecation warnings
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  def render_500
    render_exception(500, exception.message, exception)
  end


  def render_404(exception = nil)
    render_exception(404, 'Page not found', exception)
  end


  def render_exception(status = 500, message = 'Server error', exception)

    if exception
      Rails.logger.fatal "\n#{exception.class.to_s} (#{exception.message})"
      Rails.logger.fatal exception.backtrace.join("\n")
    else
      Rails.logger.fatal "No route matches [#{env['REQUEST_METHOD']}] #{env['PATH_INFO'].inspect}"
    end

    render template: "errors/#{status}", formats: [:html], layout: 'error', status: @status
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

  def after_sign_in_path_for(resource_or_scope)
    home_path
  end
end
