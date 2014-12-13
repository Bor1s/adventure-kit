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

  attributes :description, :short_description, :title, :beginning_at, :poster
end
