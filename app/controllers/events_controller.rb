class EventsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    authorize! :read, Event
    @events = EventService.call(user: current_user, q: params[:q], f: filters, page: params[:page])

    respond_with do |format|
      format.json do
        render json: @events
      end
    end
  end

  private

  def filters
    params[:f].to_s.split(',')
  end
end
