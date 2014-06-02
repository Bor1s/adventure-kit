class GameDecorator
  attr_reader :game
  attr_accessor :amount

  def initialize(game)
    @game = game
  end

  def id
    game.id
  end

  def title
    game.title
  end

  def amount
    @amount.to_i
  end
end
