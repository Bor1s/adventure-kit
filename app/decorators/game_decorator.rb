class GameDecorator
  attr_reader :game
  attr_accessor :amount

  def initialize(game)
    @game = game
  end

  def title
    game.title
  end
end
