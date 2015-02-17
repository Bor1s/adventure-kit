class SessionsController < ApplicationController

  respond_to :json

  def authorize
    if request.post?
      warden.authenticate!(:plain)
      render json: {redirect_path: (session[:request_path] || dashboard_path)}
    else
      add_account(request.env['omniauth.auth']) if user_signed_in?
      warden.authenticate!
      redirect_to (session[:request_path] || dashboard_path) and return
    end
  end

  def destroy
    warden.logout
    redirect_to root_path
  end

  def failure
    #Handles failures for both Warden and OAuth callbacks
    if params[:error].present?
      redirect_to new_registration_path
    else
      errors = warden.errors.to_hash
      error_obj = errors.each_pair {|k,v| errors[k] = I18n.t(v) }
      render json: { error: error_obj }, status: 422 #Unpocessable entity
    end
  end

  private

  #TODO rewrite to send JSON response

  def add_account(auth_hash)
    account = Account.find_or_create_by_auth_hash(auth_hash)
    #Looking that different User does not use this account
    if account.user.blank?
      flash.notice = I18n.t('messages.account_added')
      current_user.accounts << account
    else
      flash.alert = I18n.t('messages.account_busy')
    end
  end

end
