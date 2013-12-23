class MastersController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, User
    @masters = User.masters.all
  end
end
