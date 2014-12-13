class PlainAccount < Account
  EMAIL_REGEX = /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  attr_reader :password_confirmation

  field :password_digest

  #If plain account
  has_secure_password
  #validates :password, presence: true, length: {minimum: 8, maximum: 16}, confirmation: true, if: Proc.new {|a| a.provider.nil?}
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }, if: Proc.new {|a| a.provider.nil?}
end
