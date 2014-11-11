class SessionsController < ApplicationController

  def authorize
    add_account(request.env['omniauth.auth']) if user_signed_in?
    warden.authenticate!
    redirect_to events_path
  end

  def destroy
    warden.logout
    redirect_to sign_in_url
  end

  def failure
    redirect_to root_path
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
