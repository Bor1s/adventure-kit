class GameWizardService
  NUMBER_OF_STEPS = 4

  include ActiveModel::Model
  attr_accessor :title, :description, :players_amount, :address, :online_info, :private_game, :invitees, :online_game, :events_attributes, :events_ui_ids, :poster, :poster_tmp_url, :step
  attr_reader :cache_key

  validates :title, :description, presence: true, if: :step1?
  validates_with GameWizardStep2Validator
  validates_with GameWizardStep3Validator

  def initialize(cache_key, step, attributes={})
    if cache_key.present?
      @cache_key = cache_key
    else
      @cache_key = "new_game_#{SecureRandom.hex(16)}"
    end
    @step = step.to_i
    super(attributes)
  end

  def private_game?
    #Stupid, I know
    private_game == 'true'
  end

  def online_game?
    #Stupid, I know
    online_game == 'true'
  end

  # --- Steps ---
  def step1?
    step == 1
  end

  def step2?
    step == 2
  end

  def step3?
    step == 3
  end

  def step4?
    step == 4
  end

  def last_step?
    step >= NUMBER_OF_STEPS
  end
  # ---

  def persist_step
    #TODO refactor with hmset and avoid block
    case step
    when 1
      Sidekiq.redis do |conn|
        conn.hset(cache_key, 'title', title)
        conn.hset(cache_key, 'description', description)
      end
      cache_key
    when 2
      Sidekiq.redis do |conn|
        if private_game?
          conn.hset(cache_key, 'private_game', true)
          conn.hset(cache_key, 'invitees', JSON.generate(invitees))
        else
          conn.hset(cache_key, 'private_game', false)
          conn.hset(cache_key, 'players_amount', players_amount)
        end

        if online_game?
          conn.hset(cache_key, 'online_game', true)
          conn.hset(cache_key, 'online_info', online_info)
        else
          conn.hset(cache_key, 'online_game', false)
          conn.hset(cache_key, 'address', address)
        end
      end
      cache_key
    when 3
      Sidekiq.redis do |conn|
        conn.hset(cache_key, 'events_attributes', JSON.generate(events_attributes))
      end
      cache_key
    when 4
      poster_tmp_url = tmpfilename = Rails.root.join('tmp', 'cache', "#{cache_key}_poster")
      File.open(tmpfilename,'w') do |file|
        file.write Base64.decode64(poster.sub('data:image/png;base64,','')).force_encoding('UTF-8')
      end

      Sidekiq.redis do |conn|
        conn.hset(cache_key, 'poster_url', poster_tmp_url)
      end
      cache_key
    end
  end
end
