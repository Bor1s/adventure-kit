module UserConcern
  def user_params
    #TODO need to explicitly remove :password if :password_confirmation is blank
    #because has_secure_password allow to update password field anyway on record update
    if params[:user][:plain_account_attributes].present? && params[:user][:plain_account_attributes][:password_confirmation].blank?
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
end
