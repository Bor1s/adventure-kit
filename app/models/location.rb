class Location
  attr_accessor :text_coordinates

  include Mongoid::Document
  include Geocoder::Model::Mongoid
  
  belongs_to :game
  
  field :coordinates, type: Array, default: [30.4823803, 50.4397198]
  field :address, type: String
  
  reverse_geocoded_by :coordinates
  before_validation :convert_coordinates
  after_validation :reverse_geocode

  def lat
    coordinates and to_coordinates.first
  end

  def lng
    coordinates and to_coordinates.last
  end

  private

  def convert_coordinates
    Geocoder.configure(language: I18n.locale.to_s)
    if text_coordinates.present?
      coords = text_coordinates.split(',')
      self.coordinates = [coords[1].to_f, coords[0].to_f]
    end
  end
end
