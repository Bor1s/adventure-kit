class AccountsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    @accounts = Account.all
    render json: @accounts
  end
end
