class ProviderDataExtractor
  attr_reader :provider_name, :data

  def initialize(provider_name, data)
    @provider_name = provider_name
    @data = data
  end

  def extract_data
    case provider_name
    when 'vkontakte'
      VkDataExtractor.extract(data)
    when 'gplus'
      GPlusDataExtractor.extract(data)
    end
  end
end
