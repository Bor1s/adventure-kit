class EventSerializer < ActiveModel::Serializer

  def beginning_at
    object.beginning_at.strftime('%d-%m-%Y %H:%M')
  end

  def short_description
    object.description.truncate(135)
  end

  def title
    object.game.title
  end

  def poster
    object.game.poster
  end

  def location
    object.game.location
  end

  def online
    object.online?
  end

  attributes :description, :short_description, :title, :beginning_at, :poster,
    :location, :online
end
