class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #rescue_from ActionController::RoutingError,
  #  ActionController::UnknownController,
  #  ActionController::RoutingError,
  #  ActionController::UnknownFormat,
  #  Mongoid::Errors::DocumentNotFound, with: :not_found

  rescue_from CanCan::AccessDenied, with: :prohibited

  helper_method :current_user, :current_user_profile, :user_signed_in?
  around_filter :set_timezone
  before_filter :verfify_not_signed_in, only: [:welcome]

  def welcome
    render layout: 'basic'
  end

  def routing_error_handler
    render '/public/404.html', status: 404, layout: false
  end

  private

  def authenticate
    unless warden.authenticated?
      session[:request_path] = request.env['REQUEST_URI']
      redirect_to(new_registration_path)
    end
  end

  def warden
    request.env['warden']
  end

  def user_signed_in?
    warden.authenticated?
  end

  def verfify_not_signed_in
    if warden.authenticated?
      redirect_to dashboard_path, alert: 'please log out to before you can register new user'
    end 
  end

  def current_user
    #TODO Search by account and mix user and account into decorator
    @current_user ||= warden.user.user
  end

  def current_user_profile
    #Means Account
    @current_user_profile ||= warden.user
  end

  def not_found
    if request.format.json?
      render json: { success: false, message: 'Not found!' }, status: 404
    else
      render '/public/404.html', status: 404, layout: false
    end
  end

  def prohibited
    render '/public/prohibited.html', layout: false
  end

  def set_timezone
    default_timezone = Time.zone
    client_timezone  = cookies[:timezone]
    Time.zone = client_timezone if client_timezone.present?
    yield
  ensure
    Time.zone = default_timezone
  end
end
