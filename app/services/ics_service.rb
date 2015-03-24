require 'icalendar'

class IcsService
  def self.call(game_id)
    game = Game.find(game_id)
    generate_ics(game)
  end

  private
  
  def self.generate_ics(game)
    game_event = game.events.upcoming.asc(:beginning_at).first
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = game_event.beginning_at
      e.dtend       = game_event.beginning_at + 4.hours
      e.summary     = game.title
      e.description = game.description
      e.url = Rails.application.routes.url_helpers.game_url(game)
    end
    cal.to_ical
  end
end
