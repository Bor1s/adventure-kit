class GameSerializer < ActiveModel::Serializer
  def has_poster
    object.poster?
  end

  def address
    object.location.try(:address)
  end

  attributes :title, :description, :poster, :private_game, :finished, :online_game, :online_info, :players_amount, :has_poster, :address
end
