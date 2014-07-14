class LocationsController < ApplicationController
  before_action :authenticate
  respond_to :html, :json

  def index
    respond_with do |format|
      format.html do
        @lat = request.location.latitude
        @lng = request.location.longitude
        @locations = Location.near([@lat, @lng], 5).all #Near 5 miles
      end

      format.json do
        render json: Location.all
      end
    end
  end
end
