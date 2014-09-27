class GPlusDataExtractor
  def self.extract(data)
    {
      provider: data[:provider],
      uid: data[:uid],
      name: data[:info][:name],
      avatar: data[:info][:image],
      social_network_link: data[:info][:urls]['Google+']
    }
  end
end
