class Master::BaseController < ApplicationController
  layout 'master'
  respond_to :html
  before_action :authenticate, :verify_master

  private

  def verify_master
    redirect_to root_path unless current_user.master?
  end
end
