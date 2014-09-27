require 'rails_helper'

describe TagSearchService do

  before :all do
    User.destroy_all
    Tag.destroy_all
    Game.destroy_all

    FactoryGirl.create_list(:game_with_tags, 2)
    FactoryGirl.create(:master_with_vk_account)
    FactoryGirl.create(:player_with_vk_account)
  end

  it 'returns tag matched by tag_id' do
    tag = Tag.first
    expect(described_class.new(tag.id).tag).to eq tag
  end

  it 'returns games matched by tag_id' do
    tag = Tag.first
    expect(described_class.new(tag.id).games.count).to eq 1
  end
  
  it 'returns users matched by tag_id' do
    tag = Tag.first
    User.first.tags << tag
    expect(described_class.new(tag.id).users.count).to eq 1
  end
end
