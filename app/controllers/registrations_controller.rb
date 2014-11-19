class RegistrationsController < ApplicationController
  before_filter :verfify_not_signed_in

  layout 'basic'

  def new
    @user = User.new
    @account = @user.accounts.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      warden.set_user(@user.accounts.first)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, accounts_attributes: [:password, :password_confirmation])
  end
end
