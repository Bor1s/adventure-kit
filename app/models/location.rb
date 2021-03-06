class Location
  #attr_accessor :text_coordinates

  include Mongoid::Document
  include Geocoder::Model::Mongoid
  
  belongs_to :game
  
  field :coordinates, type: Array, default: [30.4823803, 50.4397198]
  field :address, type: String

  validates :address, presence: true
  
  geocoded_by :address
  #before_validation :convert_coordinates
  after_validation :geocode, if: ->(obj) {obj.address.present? and obj.address_changed?}

  def lat
    coordinates and to_coordinates.first
  end

  def lng
    coordinates and to_coordinates.last
  end

  #def as_json(options={})
  #  options.merge!({lat: lat, lng: lng, title: self.game.title, url: Rails.application.routes.url_helpers.game_path(self.game)})
  #end

  #private

  #def convert_coordinates
  #  Geocoder.configure(language: I18n.locale.to_s)
  #  if text_coordinates.present?
  #    coords = text_coordinates.split(',')
  #    self.coordinates = [coords[1].to_f, coords[0].to_f]
  #  end
  #end
end
