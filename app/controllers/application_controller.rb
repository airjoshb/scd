class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :get_user_prefs
  before_filter :last_page

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  config.on_unauthorized_access = :access_denied
  helper_method :date_of_next

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.admin?
        edit_user_registration_path || root_path
      else
        edit_user_registration_path || root_path
      end
  end


  def date_of_next(day)
    date  = Date.parse(day)
    delta = date > Date.today ? 0 : 7
    date + delta
  end

  def last_page
    session[:last_page] = request.env['HTTP_REFERER']
  end


  def get_user_prefs
    if current_user.present?
      @tags = current_user.tags
    end
  end

  protected

  #->Prelang (user_login:devise)
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)        { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in)        { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :name) }
  end

  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end

  private

  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
