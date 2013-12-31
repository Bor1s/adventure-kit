class Tag
  include Mongoid::Document
  has_and_belongs_to_many :users
  has_and_belongs_to_many :games
end
