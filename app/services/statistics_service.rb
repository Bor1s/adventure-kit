class StatisticsService

  class GameDecorator
    attr_reader :game, :amount

    def initialize(game, amount)
      @game = game
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
        id = d['game']['$oid'].present? ? d['game']['$oid'] : d['game']
        game = Game.where(id: id).first
        if game.present?
          GameDecorator.new(game, d['amount'])
        end
      end
    end
  end
end
