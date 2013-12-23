class GenrePresenter
  attr_reader :entry, :entries

  def initialize model
    if model.is_a? Array
      @entries = model.map {|m| m.extend(ClassMethods)}
    else
      model.extend ClassMethods
      @entry = model
    end
  end

  module ClassMethods

    # Place presenter methods here
    def total_games
      42
    end

    def total_players
      79
    end

    def games_finished
      30
    end

    def games_in_progress
      12
    end
  end
end
