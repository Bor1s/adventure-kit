class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError,
    ActionController::UnknownController,
    ActionController::RoutingError,
    Mongoid::Errors::DocumentNotFound,
    CanCan::AccessDenied, with: :not_found

  helper_method :current_user, :current_user_profile, :user_signed_in?

  around_filter :set_timezone

  def sign_in
    render layout: 'landing'
  end

  def routing_error_handler
    render '/public/404.html', status: 404
  end

  private

  def current_user
    #TODO Search by account and mix user and account into decorator
    @current_user ||= Account.where(id: session[:account_id]).first.user if session[:account_id]
  end

  def current_user_profile
    @current_user_profile ||= Account.where(id: session[:account_id]).first if session[:account_id]
  end

  def user_signed_in?
    session[:account_id].present?
  end

  def authenticate
    redirect_to sign_in_path unless user_signed_in?
  end

  def not_found
    if request.format.json?
      render json: { success: false, message: 'Not found!' }, status: 404
    else
      render '/public/404.html', status: 404
    end
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
