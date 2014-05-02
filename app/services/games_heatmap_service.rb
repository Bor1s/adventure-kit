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
      @data << {x: column,
                y: row,
                day: date.mday,
                name: I18n.t(Date::MONTHNAMES[date.month]),
                _full_date: date.rfc2822,
                value: daily_events["#{date.mday}/#{date.month}"]}
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

end
