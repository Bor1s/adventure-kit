class VkDataExtractor
  def self.extract(data)
    {
      provider: data[:provider],
      uid: data[:uid],
      name: data[:info][:first_name],
      avatar: data[:info][:image],
      avatar_original: data[:extra][:raw_info][:photo_200_orig],
      avatar_medium: data[:extra][:raw_info][:photo_100],
      social_network_link: data[:info][:urls][:Vkontakte]
    }
  end
end
