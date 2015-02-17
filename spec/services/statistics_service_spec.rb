require 'rails_helper'

describe StatisticsService do
  let(:top_games_fake_statistics) {
    [
      {game: FactoryGirl.create(:game).id, amount: 3},
      {game: FactoryGirl.create(:game).id, amount: 5}
    ]
  }

  before do
    test = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/games/top') { [200, {}, top_games_fake_statistics.to_json] }
      end
    end

    allow(subject).to receive(:connection).and_return(test)
  end

  it 'returns #top_games' do
    pending 'Rework statistics service'
    expect(subject.top_games).to be_an_instance_of(Array)
    expect(subject.top_games.sample).to be_an_instance_of(GameDecorator)
  end

  it 'returns [] if no data' do
    test = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/games/top') { [200, {}, [].to_json] }
      end
    end
    allow(subject).to receive(:connection).and_return(test)

    expect(subject.top_games).to be_empty
  end

end
