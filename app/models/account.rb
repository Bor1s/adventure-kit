class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  # Mandatory fields
  field :email, type: String
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :nickname, type: String

  #Additional fields
  field :avatar, type: String
  field :avatar_medium, type: String
  field :avatar_original, type: String
  field :social_network_link, type: String

  belongs_to :user

  def self.find_or_create_by_auth_hash(auth_hash)
    account_data_extractor = ProviderDataExtractor.new(auth_hash[:provider], auth_hash)
    account_data = account_data_extractor.extract_data

    account = Account.where(uid: auth_hash[:uid]).first
    if account.present?
      account.update_attributes(account_data) and account #explicitly return account document
    else
      Account.create(account_data)
    end
  end

end
