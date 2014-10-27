class EventsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, Event

    @events = EventService.call(q: params[:q], f: params[:f], page: params[:page])
  end
end
