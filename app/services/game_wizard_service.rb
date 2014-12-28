class GameWizardService
  NUMBER_OF_STEPS = 2

  include ActiveModel::Model
  attr_accessor :title, :description, :players_amount, :step
  attr_reader :cache_key

  validates :title, :description, presence: true, if: :step1?

  def initialize(cache_key, step, attributes={})
    if cache_key.present?
      @cache_key = cache_key
    else
      @cache_key = "new_game_#{SecureRandom.hex(16)}"
    end
    @step = step.to_i
    super(attributes)
  end

  def step1?
    step == 1
  end

  def last_step?
    step >= NUMBER_OF_STEPS
  end

  def persist_step
    case step
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
