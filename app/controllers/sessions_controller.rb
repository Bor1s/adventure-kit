class SessionsController < ApplicationController
  def create
    auth_hash.merge!({current_timezone_offset: Time.zone.now.utc_offset})
    @user = User.find_or_create_by_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_url
  end

  def failure
    redirect_to sign_in_url, alert: params[:message]
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
