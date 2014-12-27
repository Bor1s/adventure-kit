class GameWizardService
  include ActiveModel::Model
  attr_accessor :title, :description, :players_amount, :step
  attr_reader :cache_key

  validates :title, :description, presence: true, if: :step1?

  def initialize(attributes={})
    @cache_key = "game_#{SecureRandom.hex(16)}"
    super
  end

  def step1?
    step.to_i == 1
  end

  def persist_step
    case step.to_i
    when 1
      Sidekiq.redis do |conn|
        conn.hset(cache_key, 'title', title)
        conn.hset(cache_key, 'description', description)
      end
      cache_key
    when 2
    when 3
    end
  end
end
