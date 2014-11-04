class SessionsController < ApplicationController

  def authorize
    warden.authenticate!
    redirect_to events_path
  end

  def create
    #if session[:account_id].present?
    #  add_user_account(auth_hash)
    #  #NOTE Change route to smt sensible
    #  redirect_to root_url
    #else
    #  create_user_account(auth_hash)
    #  redirect_to root_url
    #end
  end

  def destroy
    warden.logout
    redirect_to sign_in_url
  end

  def failure
    redirect_to root_path
  end

  private

  #def auth_hash
  #  request.env['omniauth.auth']
  #end

  #def create_user_account(auth_hash)
  #  account = Account.find_or_create_by_auth_hash(auth_hash)
  #  if account.user.blank?
  #    user = User.create({current_timezone_offset: Time.zone.now.utc_offset})
  #    user.accounts << account
  #  end
#
  #  session[:account_id] = account.id
  #end

  def add_user_account(auth_hash)
    account = Account.find_or_create_by_auth_hash(auth_hash)
    if account.user.blank?
      flash.notice = I18n.t('messages.account_added')
      current_user.accounts << account
    else
      flash.alert = I18n.t('messages.account_busy')
    end
  end

end
