module UserConcern
  def user_params
    params.require(:user).permit(:email, :tag_ids, :want_to_be_master, :avatar, :avatar_cache, :nickname, :remove_avatar)
  end

  def handle_account_in_session(account)
    #Assigns another user account to session
    if account == current_user_profile
      new_session_account = current_user.accounts.ne(uid: account.uid).first
      session[:account_id] = new_session_account.id
    end
    account.destroy
  end

  def last_account?
    current_user.accounts.count == 1
  end
end
