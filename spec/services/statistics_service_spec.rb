require 'spec_helper'

describe StatisticsService do
  subject { StatisticsService }

  let(:top_games_fake_statistics) {[{game: FactoryGirl.create(:game).id, amount: 3}]}

  it 'returns .top_games' do
    allow(subject).to receive(:top_games).and_return(top_games_fake_statistics)
    subject.top_games
  end

end
