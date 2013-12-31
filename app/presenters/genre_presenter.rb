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
      games.count
    end

    def total_players
      users.count
    end

    def games_finished
      games.finished.count
    end

    def games_in_progress
      games.pending.count
    end
  end
end
