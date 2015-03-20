class Master::AccountsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    respond_with do |format|
      format.json do
        accounts = current_user.accounts.asc(:created_at)
        render json: accounts
      end
    end
  end

  def update
    account = current_user.accounts.find(params[:id])
    if account.update_attributes(account_attributes)
      render json: account
    else
      render json: {success: false}, status: 422
    end
  end

  private

  def account_attributes
    params.require(:account).permit(:open_to_others)
  end
end
