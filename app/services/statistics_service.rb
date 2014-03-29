class StatisticsService

  class GameDecorator
    attr_reader :game, :amount

    def initialize(id, amount)
      @game = Game.find(id)
      @amount = amount.to_i
    end

    def title
      game.title
    end
  end

  class << self
    def top_games 
      response = Faraday.get "#{Rails.application.config.harvester.host}/games/top"
      data = JSON.parse(response.body)
      data.map do |d|
        GameDecorator.new(d['game']['$oid'].present? ? d['game']['$oid'] : d['game'], d['amount'])
      end
    end
  end
end
