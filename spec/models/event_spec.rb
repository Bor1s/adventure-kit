require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    Game.destroy_all
    Event.destroy_all
    FactoryGirl.create(:game_with_upcoming_events)
    FactoryGirl.create(:game_with_finished_events)
  end

  it { is_expected.to respond_to(:game) }

  it 'returns .upcoming' do
    expect(described_class.upcoming.count).to eq 1
  end

  it 'returns .finished' do
    expect(described_class.upcoming.count).to eq 1
  end

  context 'valid' do
    it 'with beginning_at' do
      expect(described_class.new(beginning_at: Time.now)).to be_valid
    end
  end

  context 'invalid' do
    it { is_expected.to be_invalid }
  end
end
