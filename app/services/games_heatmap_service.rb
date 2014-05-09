class GamesHeatmapService
  attr_reader :data, :x_axis_step

  def initialize
    service = StatisticsService.new
    daily_events = service.daily_events_amount
    date_range = ((Date.today - 1.month)..(Date.today + 1.month))

    @data = []
    @x_axis_step = calculate_step(date_range)

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
                value: daily_data.size}
      column += 1 if row == 6
    end
  end

  private

  def calculate_step(date_range)
    days = date_range.count
    # Set the step of showing labels on xAxis of highchart
    # depending on a week amount in current date range
    days.divmod(7)[1].present? ? 4 : 3
  end

  def fetch_events_data(event_ids)
    Event.where(:id.in => event_ids).map do |event|
      {title: event.game.title, beginning_at: I18n.l(event.beginning_at, format: :hm) }
    end
  end

end
