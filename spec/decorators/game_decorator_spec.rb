require 'rails_helper'

RSpec.describe GameDecorator, type: :decorator do
  subject {described_class.new(FactoryGirl.create(:game))}

  it {is_expected.to respond_to(:id)}
  it {is_expected.to respond_to(:title)}
  it {is_expected.to respond_to(:description)}
  it {is_expected.to respond_to(:address)}
  it {is_expected.to respond_to(:online_info)}
  it {is_expected.to respond_to(:online_game?)}
  it {is_expected.to respond_to(:players)}
  it {is_expected.to respond_to(:next_session)}
  it {is_expected.to respond_to(:poster)}
end
