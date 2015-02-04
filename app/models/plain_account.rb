class PlainAccount < Account
  EMAIL_REGEX = /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  attr_reader :password_confirmation

  field :password_digest

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }, if: Proc.new {|a| a.provider.nil?}
end
