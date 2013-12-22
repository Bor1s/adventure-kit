Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :vkontakte, 3843921, 'CwcV4V1XVNQVyVjdueTP'
end
