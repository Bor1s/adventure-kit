class Admin::BaseController < ApplicationController
  layout 'admin'
  respond_to :html
  before_action :authenticate, :verify_admin

  private

  def verify_admin
    redirect_to root_path unless current_user.admin?
  end
end
