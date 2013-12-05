class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :create_user
  before_filter :set_current_user
  before_filter :set_locale

  def url_options
    super
    @_url_options.dup.tap do |options|
      options[:protocol] = Rails.env.production? ? "https://" : "http://"
      options.freeze
    end
  end

  #continue to use rescue_from in the same way as before
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception do |e|
      render_error(e)
    end
    rescue_from CanCan::AccessDenied do |exception|
      unless current_user
        authenticate_user!
      else
        redirect_to home_path, {:exception => exception, :notice => "Sorry, you don't have permissions to access this page." }
      end
      flash.now[:alert] = exception.message
    end
    rescue_from ActionController::RoutingError, with: :render_not_found
    rescue_from ActionController::UnknownController, with: :render_not_found
    rescue_from AbstractController::ActionNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  end

  #render 500 error
  def render_error(e)
    ExceptionNotifier.notify_exception(e) if Rails.env.eql? 'production'
    render layout: 'landing_page', :template => "errors/500", :status => 500
  end

  #render 404 error
  def render_not_found
    render layout: 'landing_page', :template => "errors/404", :status => 404
  end

  private
  def set_current_user
    User.current = current_user
  end

  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    
    url = session.delete("#{scope}_return_to")
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  end

  # localization settings
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end 


end
