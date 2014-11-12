require 'rails_helper'

describe Master::ProfilesController do

  before do
    User.destroy_all
    Tag.destroy_all
    
    user = FactoryGirl.create(:master_with_vk_account)
    sign_in user.accounts.first
  end

  context 'requesting' do
    it '#edit returns status OK' do
      get :edit
      expect(response.status).to eq 200
    end

    describe '#update' do
      let(:user) { User.first }
      let(:user_params) {
        {email: 'new@gmail.com', want_to_be_master: 0, tag_ids: ''}
      }
      subject { put :update, {id: user.id, user: user_params} }

      it 'updates user' do
        expect(subject).to redirect_to(edit_player_profile_path)
        expect(user.reload.human_role).to eq 'player'
      end

      it 'creates new tag' do
        expect { put :update, {id: user.id, user: user_params.merge(tag_ids: 'awesome_tag_new,53b7a7')} }.to change(Tag, :count).by(1)
      end
    end

    describe '#remove_account' do
      let(:user) { User.first }

      it 'renders :edit when name parameter is missing' do
        delete :remove_account, {}
        expect(response.status).to eq 200
      end

      it 'removes VK account' do
        delete :remove_account, {name: 'vkontakte'}
        expect(response.status).to eq 302
      end

      it 'removes GPlus account' do
        add_account(user, 'gplus')
        delete :remove_account, {name: 'gplus'}
        expect(response.status).to eq 302
      end

      it 'does not remove last account' do
        delete :remove_account, {name: 'vkontakte'}
        expect(flash[:alert]).to eq 'You cannot delete last account'
        expect(user.accounts.count).to eq 1
      end
    end

  end
end
