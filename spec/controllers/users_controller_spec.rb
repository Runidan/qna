# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let(:user) { create(:user) }

  describe 'GET #show' do
    it 'assigns the requested user profile' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the :show template' do
      get :show, params: { id: user.id }
      expect(response).to render_template :show
    end
  end
end
