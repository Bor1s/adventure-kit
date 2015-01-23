class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  #include SolrService::MongoidHooks
  include Notification

  #field :description, type: String
  #field :online, type: Mongoid::Boolean, default: false
  field :beginning_at, type: DateTime

  #mount_uploader :poster, PosterUploader

  belongs_to :game

  delegate :title, to: :game, allow_nil: true

  validates :beginning_at, presence: true

  #NOTE Scopes uses additional sum for utc_offset because of Mongoid bug
  scope :upcoming, -> { where(:beginning_at.gte => (Time.zone.now + Time.zone.now.utc_offset), :beginning_at.lte => (Time.zone.now + 1.month).beginning_of_day).asc(:beginning_at) }
  scope :for_today, -> { where(:beginning_at.gte => (Time.zone.now.beginning_of_day + Time.zone.now.utc_offset), :beginning_at.lte => (Time.zone.now.end_of_day + Time.zone.now.utc_offset)).asc(:beginning_at) }
  scope :finished, -> { where(:beginning_at.lte => (Time.zone.now + Time.zone.now.utc_offset)).asc(:beginning_at) }
  scope :for_games, ->(game_ids) { where(:game_id.in => game_ids) }
  scope :nearest, -> { where(:beginning_at.gte => (Time.zone.now + Time.zone.now.utc_offset), :beginning_at.lte => (Time.zone.now.tomorrow.end_of_day + Time.zone.now.utc_offset)) }

  def finished?
    beginning_at < Time.zone.now
  end

  #def solr_index_data(options={})
    #data = {id: id}
    #data[:ctext] = [options[:title] || title, options[:description] || self.game.description].join(' ')
    #data
  #end
end
