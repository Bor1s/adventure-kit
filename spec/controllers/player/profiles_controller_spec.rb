require 'rails_helper'

describe Player::ProfilesController do
  before do
    User.destroy_all
    Tag.destroy_all
    sign_in_user_via_vk(:player)
  end

  context 'requesting' do
    it '#edit returns status OK' do
      get :edit
      expect(response.status).to eq 200
    end

    describe '#update' do
      let(:user) { User.first }
      let(:user_params) {
        {name: 'New name', email: 'new@gmail.com', want_to_be_master: 1, tag_ids: ''}
      }
      subject { put :update, {id: user.id, user: user_params} }

      it 'updates user' do
        expect(subject).to redirect_to(edit_player_profile_path)
        expect(user.reload.human_role).to eq 'master'
      end

      it 'creates new tag' do
        expect { put :update, {id: user.id, user: user_params.merge(tag_ids: 'awesome_tag_new,53b7a7')} }.to change(Tag, :count).by(1)
      end
    end

  end
end
