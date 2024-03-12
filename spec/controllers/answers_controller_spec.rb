# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question.id } }

    it 'redirects to the question show page' do
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        login(user)
        post :create, params: { question_id: question.id, answer: { body: 'Answer body' }, user_id: user.id }
      end

      it 'creates a new answer' do
        expect(Answer.last.body).to eq('Answer body')
      end

      it 'redirect to question page' do
        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question.id, answer: { body: '' } }
        end.not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question.id, answer: { body: '' } }
        expect(response).to render_template('questions/show')
      end
    end
  end
end
