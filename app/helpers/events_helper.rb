module EventsHelper
  def activity(state)
    'active' if (state == 'upcoming' and params[:f].blank?) || (params[:f] == state)
  end
end
