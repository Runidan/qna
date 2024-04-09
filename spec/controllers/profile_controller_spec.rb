require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:profile) { user.profile }
  
  before do
    sign_in user
  end
  
  describe 'GET #show' do
    it 'assigns the requested profile to @profile' do
      get :show, params: { id: profile.id }
      expect(assigns(:profile)).to eq(profile)
    end

    it 'renders the :show template' do
      get :show, params: { id: profile.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested profile to @profile' do
      get :edit, params: { id: profile.id }
      expect(assigns(:profile)).to eq(profile)
    end

    it 'renders the :edit template' do
      get :edit, params: { id: profile.id }
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the profile' do
        patch :update, params: { id: profile.id, profile: { name: 'New Name' } }
        profile.reload
        expect(profile.name).to eq('New Name')
      end

      it 'redirects to the profile' do
        patch :update, params: { id: profile.id, profile: { name: 'New Name' } }
        expect(response).to redirect_to(profile_path(profile))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the profile' do
        expect {
          patch :update, params: { id: profile.id, profile: { name: nil } }
        }.not_to change { profile.reload.name }
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: profile.id, profile: { name: nil } }
        expect(response).to render_template :edit
      end
    end
  end
end