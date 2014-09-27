Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :vkontakte, 3843921, 'CwcV4V1XVNQVyVjdueTP'
  provider :gplus, '606304173142-pkc72a4prsp83h71c84ud00nrm5f7bc4.apps.googleusercontent.com', 'Q31NL3DCqO9OBnfRGPMcuIuf'
end
