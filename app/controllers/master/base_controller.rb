class Master::BaseController < ApplicationController
  layout 'single_panel'
  respond_to :html, :json
  before_action :authenticate
end
