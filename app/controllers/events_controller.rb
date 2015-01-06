class EventsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    authorize! :read, Event

    if params[:game_id].present?
      @events = Game.find(params[:game_id]).events
    else
      @events = fetch_events(params)
    end

    respond_with do |format|
      format.json do
        render json: @events
      end
    end
  end

  private

  def fetch_events(params)
    event_filter_service = EventFilterService.new(current_user, filters)
    filtered_events = event_filter_service.filter
    event_search_service = EventSearchService.new(filtered_events, params[:q], params[:page])
    event_search_service.search
  end

  def filters
    params[:f].to_s.split(',')
  end
end
