class GamesHeatmapService
  include ActionView::Helpers::UrlHelper

  attr_reader :data, :human_date_range

  def initialize
    service = StatisticsService.new
    daily_events = service.daily_events_amount
    #Change range to increase amount of tiles on the heatmap
    date_range = ((Date.today - 2.month)..(Date.today + 2.month))
    @human_date_range = date_range.map { |date| I18n.t(Date::MONTHNAMES[date.month]) }.uniq.join(' ')

    @data = []

    column = 0
    date_range.each do |date|
      row = date.sunday? ? 6 : (date.wday-1)
      daily_data = daily_events["#{date.mday}/#{date.month}"] || []
      events_data = fetch_events_data(daily_data)
      @data << {x: column,
                y: row,
                day: date.mday,
                name: I18n.t(Date::MONTHNAMES[date.month]),
                _full_date: date.rfc2822,
                human_name: I18n.t("date.abbr_month_names")[date.month],
                games: events_data,
                value: daily_data.size.zero? ? nil : daily_data.size}
      column += 1 if row == 6
    end
  end

  private

  def fetch_events_data(event_ids)
    Event.where(:id.in => event_ids).map do |event|
      {title: event.game.title,
       url: Rails.application.routes.url_helpers.game_path(event.game),
       beginning_at: I18n.l(event.beginning_at, format: :hm) }
    end
  end

end
