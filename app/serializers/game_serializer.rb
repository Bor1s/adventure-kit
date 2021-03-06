class GameSerializer < ActiveModel::Serializer
  has_many :events
  has_one :location

  def has_poster
    object.poster?
  end

  def address
    object.location.try(:address)
  end

  def total_events
    object.events.count
  end

  def short_description
    object.description.truncate(135)
  end

  def online
    object.online_game?
  end

  def next_event_date
    event = object.events.upcoming.asc(:beginning_at).first
    event.beginning_at.strftime('%d-%m-%Y %H:%M') if event.present?
  end

  def id
    object.id.to_s
  end

  def url
    Rails.application.routes.url_helpers.game_url(object, only_path: true)
  end

  def destroy_url
    Rails.application.routes.url_helpers.master_game_url(object, only_path: true)
  end

  def can_be_managed
    # scope is current_user
    scope.creator?(object)
  end

  def allows_to_take_part
    object.allows_to_take_part?
  end

  attributes :id,
    :title,
    :next_event_date,
    :description,
    :short_description,
    :poster,
    :private_game,
    :online,
    :online_game,
    :online_info,
    :players_amount,
    :has_poster,
    :address,
    :url,
    :destroy_url,
    :can_be_managed,
    :allows_to_take_part
end
