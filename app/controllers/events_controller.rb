class EventsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    authorize! :read, Event
    @events = Game.find(params[:game_id]).events
    respond_with do |format|
      format.json do
        render json: @events
      end
    end
  end
end
