class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include SolrService::MongoidHooks

  field :description, type: String
  field :beginning_at, type: DateTime

  mount_uploader :poster, PosterUploader

  belongs_to :game

  delegate :title, to: :game, allow_nil: true

  validates :description, presence: true
  validates :beginning_at, presence: true

  scope :for_week, -> { where(:beginning_at.gte => Time.now.beginning_of_day, :beginning_at.lte => (Time.now + 7.days)) }
  scope :for_games, ->(game_ids) {
    if game_ids.present?
      where(:game_id.in => game_ids)
    else
      all
    end
  }

  def finished?
    beginning_at < Time.now
  end

  def solr_index_data(options={})
    data = {id: id}
    data[:ctext] = [options[:title] || title, description].join(' ')
    data
  end
end
