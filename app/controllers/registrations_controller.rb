class RegistrationsController < ApplicationController
  before_filter :verfify_not_signed_in

  layout 'basic'

  respond_to :json

  def new
    @user = User.new
    @account = @user.accounts.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      warden.set_user(@user.accounts.first)
      render json: { account_id: current_user_profile.id }
    else
      render json: { success: false, errors: @user.accounts.first.errors.messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(accounts_attributes: [:password, :email, :password_confirmation])
  end
end
