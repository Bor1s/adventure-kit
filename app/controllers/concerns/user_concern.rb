module UserConcern
  def user_params
    #TODO need to explicitly remove :password if :password_confirmation is blank
    #because has_secure_password allow to update password field anyway on record update
    if params[:user][:plain_account_attributes][:password_confirmation].blank?
      params[:user][:plain_account_attributes].delete(:password)
    end

    params.require(:user).permit(:avatar, :timezone, :nickname, :bio,
                                 plain_account_attributes: [:email, :password, :password_confirmation, :id])
  end

  def update(redirect_path: root_path, render_path: :edit)
    @profile = current_user
    if @profile.update_attributes(user_params)
      render json: @profile
    else
      @profile.errors.messages.delete(:plain_account)
      render json: {success: false, errors: @profile.errors.messages.merge(@profile.plain_account.errors.messages)}, status: 422
    end
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

  def remove_account(render_path: :edit, redirect_path: root_path)
    if params[:name].present?
      account = current_user.accounts.where(provider: params[:name]).first
      if last_account?
        flash.alert = 'You cannot delete last account'
      else
        handle_account_in_session(account)
      end
      redirect_to redirect_path
    else
      render render_path
    end
  end
end
