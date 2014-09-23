require 'rails_helper'

describe UserSearchService do
  subject { UserSearchService }

  before :all do
    User.destroy_all
    FactoryGirl.create_list(:player, 5)
    FactoryGirl.create_list(:master, 2)
    FactoryGirl.create(:admin, name: 'Boris')
  end

  context 'calling' do
    it 'without parameters returns all users' do
      expect(subject.call.count).to eq 8
    end

    it 'with :q return searched users' do
      expect(subject.call(q: 'Boris').count).to eq 1
    end
    
    it 'with :f returns masters' do
      expect(subject.call(f: 'masters').count).to eq 3
    end

    it 'with :f returns players' do
      expect(subject.call(f: 'players').count).to eq 5
    end
  end
end
