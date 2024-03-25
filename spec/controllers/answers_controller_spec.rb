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
    let(:answer_params) { { body: 'This is a test answer.' } }

    before { login(user) }

    context 'with valid params' do
      it 'creates a new answer for the question' do
        expect do
          post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns the created answer to @answer' do
        post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        expect(assigns(:answer)).to be_a(Answer)
        expect(assigns(:answer).body).to eq(answer_params[:body])
      end

      it 'redirects to the question show page with anchor to the new answer' do
        post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        question.answers.last
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid params' do
      let(:answer_params) { { body: '' } }

      it 'does not create a new answer' do
        expect do
          post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        end.not_to change(Answer, :count)
      end

      it 'renders the question show page' do
        post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    before { login(user) }

    context 'with valid params' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, xhr: true
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, xhr: true
        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, xhr: true
        end.not_to change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, xhr: true
        expect(response).to render_template :update
      end
    end
  end
end
