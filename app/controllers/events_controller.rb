class EventsController < ApplicationController
  before_action :authenticate
  respond_to :json

  def index
    authorize! :read, Event
    event_filter_service = EventFilterService.new(current_user, filters)
    filtered_events = event_filter_service.filter
    event_search_service = EventSearchService.new(filtered_events, params[:q], params[:page])
    @events = event_search_service.search

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
