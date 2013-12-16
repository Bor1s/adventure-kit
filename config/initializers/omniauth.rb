Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :vkontakte, ENV['VK_APP_ID'], ENV['VK_APP_SECRET']
end
