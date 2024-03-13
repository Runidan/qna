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
          post :create, params: { question_id: question.id, answer: answer_params }
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns the created answer to @answer' do
        post :create, params: { question_id: question.id, answer: answer_params }
        expect(assigns(:answer)).to be_a(Answer)
        expect(assigns(:answer).body).to eq(answer_params[:body])
      end

      it 'redirects to the question show page with anchor to the new answer' do
        post :create, params: { question_id: question.id, answer: answer_params }
        created_answer = question.answers.last
        expect(response).to redirect_to(question_path(question, anchor: "answer-#{created_answer.id}"))
      end
    end

    context 'with invalid params' do
      let(:answer_params) { { body: '' } }

      it 'does not create a new answer' do
        expect do
          post :create, params: { question_id: question.id, answer: answer_params }
        end.not_to change(Answer, :count)
      end

      it 'renders the question show page' do
        post :create, params: { question_id: question.id, answer: answer_params }
        expect(response).to render_template('questions/show')
      end
    end
  end
end
