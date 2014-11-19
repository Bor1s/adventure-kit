class SessionsController < ApplicationController

  def authorize
    if request.post?
      warden.authenticate!(:plain)
    else
      add_account(request.env['omniauth.auth']) if user_signed_in?
      warden.authenticate!
    end

    redirect_to events_path
  end

  def destroy
    warden.logout
    redirect_to root_path
  end

  def failure
    #Handles failures for both Warden and OAuth callbacks
    url = ((warden.message == 'warden.unauthorized') || params[:error].present?) ? new_registration_path : root_path
    redirect_to url, alert: I18n.t(warden.message || params[:error])
  end

  private

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
