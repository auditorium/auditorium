class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :create_user
  before_filter :set_current_user
  before_filter :set_locale
  before_filter :store_location

  # rescue_from CanCan::AccessDenied do |exception|
  #   if current_user.present?
  #     redirect_to root_url, alert: exception.message
  #   else
  #     redirect_to new_user_session_path, alert: exception.message
  #   end
  # end


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

      rescue_from CanCan::AccessDenied do |e|
        if current_user.present?
          redirect_to root_url
        else
          redirect_to new_user_session_path
        end
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

  # ============================
  # GAMIFICATION METHODS
  # ============================
  def achieve_editor_badge(user)
    if !user.has_badge?('editor', 'bronze')
      user.add_badge('editor', 'bronze')
      flash[:badge] = t('badges.flash.achieved_editor.bronze') if user.experimental_group? and request
    end
  end

  def achieve_party_badge(user)
    if !user.has_badge?('party', 'silver')
      user.add_badge('party', 'silver')
      flash[:badge] = t('badges.flash.achieved_party.silver') if user.experimental_group? and request
    end
  end

  def achieve_rewarding_badge(user)
    if !user.has_badge?('rewarding', 'bronze')
      user.add_badge('rewarding', 'bronze')
      flash[:badge] = t("badges.flash.achieved_rewarding.'bronze'") if user.experimental_group? and request
    end
  end

  def achieve_critical_badge(user)
    if !user.has_badge?('critical', 'bronze')
      user.add_badge('critical', 'bronze')
      flash[:badge] = t("badges.flash.achieved_critical.bronze") if user.experimental_group? and request
    end
  end

  def achieve_post_badge(user, post_type)
    case post_type
    when 'Question'
      achieve_learning_badge(user, 'bronze', 1)
      achieve_learning_badge(user, 'silver', 5)
      achieve_learning_badge(user, 'gold', 10)
    when 'Answer'
      achieve_cooperative_badge(user, 'bronze', 1)
      achieve_cooperative_badge(user, 'silver', 5)
      achieve_cooperative_badge(user, 'gold', 10)
    when 'Announcement'
      achieve_significant_badge(user, 'bronze', 1)
      achieve_significant_badge(user, 'silver', 5)
      achieve_significant_badge(user, 'gold', 10)
    when 'Topic'
      achieve_something_to_say_badge(user, 'bronze', 1)
      achieve_something_to_say_badge(user, 'silver', 5)
      achieve_something_to_say_badge(user, 'gold', 10)
    when 'Comment'
      achieve_commenter_badge(user, 'bronze', 1)
      achieve_commenter_badge(user, 'silver', 5)
      achieve_commenter_badge(user, 'gold', 10)
    end
  end

  def achieve_learning_badge(user, category, threshold)
    if !user.has_badge?('learning', category) and user.questions.where('rating >= ?', threshold).size > 0
      user.add_badge('learning', category)
      flash[:badge] = t("badges.flash.achieved_learning.#{category}") if user.experimental_group? and request
    end
  end

  def achieve_cooperative_badge(user, category, threshold)
    if !user.has_badge?('cooperative', category) and user.answers.where('rating >= ?', threshold).size > 0
      user.add_badge('cooperative', category)
      flash[:badge] = t("badges.flash.achieved_cooperative.#{category}") if user.experimental_group? and request
    end
  end

  def achieve_something_to_say_badge(user, category, threshold)
    if !user.has_badge?('something_to_say', category) and user.topics.where('rating >= ?', threshold).size > 0
      user.add_badge('something_to_say', category)
      flash[:badge] = t("badges.flash.achieved_something_to_say.#{category}") if user.experimental_group? and request
    end
  end

  def achieve_significant_badge(user, category, threshold)
    if !user.has_badge?('significant', category) and user.announcements.where('rating >= ?', threshold).size > 0
      user.add_badge('significant', category)
      flash[:badge] = t("badges.flash.achieved_significant.#{category}") if user.experimental_group? and request
    end
  end

  def achieve_commenter_badge(user, category, threshold)
    if !user.has_badge?('commenter', category) and user.comments.where('rating >= ?', threshold).size > 0
      user.add_badge('commenter', category)
      flash[:badge] = t("badges.flash.achieved_commenter.#{category}") if user.experimental_group? and request
    end
  end

  def achieve_biographer_badge(user)
    if user.profile_progress_percentage == 100 and !user.has_badge?('biographer', 'silver')
      user.add_badge('biographer', 'silver')
      flash[:badge] = t('badges.flash.achieved_biographer.silver') if user.experimental_group? and request
    elsif user.profile_progress_percentage < 100 and user.has_badge?('biographer', 'silver')
      user.remove_badge('biographer', 'silver')
    end
  end

  def achieve_curious_badge(user, tutorial_progress)
    if tutorial_progress.percentage == 100 and !user.has_badge?('curious', 'silver')
      user.add_badge('curious', 'silver')
      flash[:badge] = t('badges.flash.achieved_curious.silver') if user.experimental_group? and request
    end
  end

  def achieve_helpful_badge(user)
    if !user.has_badge?('helpful', 'bronze') and user.answers.keep_if { |a| !a.answer_to_id.nil? }.size >= 1
      user.add_badge('helpful', 'bronze')
      flash[:badge] = t('badges.flash.achieved_helpful.bronze') if user.experimental_group? and request
    end

    if !user.has_badge?('helpful', 'silver') and user.answers.keep_if { |a| !a.answer_to_id.nil? }.size >= 5
      user.add_badge('helpful', 'silver')
      flash[:badge] = t('badges.flash.achieved_helpful.silver') if user.experimental_group? and request
    end

    if !user.has_badge?('helpful', 'gold') and user.answers.keep_if { |a| !a.answer_to_id.nil? }.size >= 10
      user.add_badge('helpful', 'gold')
      flash[:badge] = t('badges.flash.achieved_helpful.gold') if user.experimental_group? and request
    end
  end

  def achieve_first_step_badge(user)
    if !user.has_badge?('first_step', 'bronze')
      user.add_badge('first_step', 'bronze')
      flash[:badge] = t('badges.flash.achieved_first_step.bronze') if user.experimental_group? and request
    end
  end

  def achieve_moderator_badge(user)
    unless user.has_badge?('moderator', 'silver')
      user.add_badge('moderator', 'silver') if user.experimental_group? and request
    end
  end

  private
  def set_current_user
    User.current = current_user
  end

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # localization settings
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end 
end
