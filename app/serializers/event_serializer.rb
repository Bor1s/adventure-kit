class EventSerializer < ActiveModel::Serializer

  def beginning_at
    object.beginning_at.strftime('%d-%m-%Y %H:%M')
  end

  def id
    object.id.to_s
  end

  attributes :id, :beginning_at
end
