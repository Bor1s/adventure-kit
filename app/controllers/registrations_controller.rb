class RegistrationsController < ApplicationController
  before_filter :verfify_not_signed_in
  layout 'basic'
  respond_to :json

  def new
    @user = User.new
    @account = @user.build_plain_account
  end

  def create
    @user = User.new(user_params)
    if @user.save
      warden.set_user(@user.plain_account)
      render json: { success: true }
    else
      render json: { success: false, errors: @user.plain_account.errors.messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(plain_account_attributes: [:password, :email, :password_confirmation])
  end
end
