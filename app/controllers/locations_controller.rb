class LocationsController < ApplicationController
  before_action :authenticate
  respond_to :html, :json

  def index
    respond_with do |format|
      format.html do
        @lat = request.location.latitude
        @lng = request.location.longitude
      end

      format.json do
        render json: Location.near([params[:lat], params[:lng]], 5).all
      end
    end
  end
end
