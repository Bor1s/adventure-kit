class StatisticsService
  attr_reader :host

  def initialize
    @host = Rails.application.config.harvester.host
  end

  def connection
    Faraday.new(url: host) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def top_games
    response = connection.get('/games/top')
    data = JSON.parse(response.body)
    result = []
    data.each do |d|
      id = d['game']['$oid'].present? ? d['game']['$oid'] : d['game']
      game = Game.where(id: id).first
      if game.present?
        decorator = GameDecorator.new(game)
        decorator.amount = d['amount']
        result << decorator
      end
    end

    result
  end
end
