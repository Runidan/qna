# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:other_user) { create(:user) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }


  describe 'GET #index' do
    before { get :index, params: { question_id: question.id } }

    it 'redirects to the question show page' do
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'POST #create' do
    let(:answer_params) { { body: 'This is a test answer.' } }

    context 'as an authenticated user with valid params' do
      before { login(user) }

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
    end

    context 'as an authenticated user with invalid params' do
      let(:answer_params) { { body: '' } }

      before { login(user) }

      it 'does not create a new answer' do
        expect do
          post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        end.not_to change(Answer, :count)
      end
    end

    context 'as a guest with valid params' do
      it 'does not create a new answer' do
        expect do
          post :create, params: { question_id: question.id, answer: answer_params }, xhr: true
        end.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    context 'with valid params' do
      before { login(user) }

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
      before { login(user) }

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

    context 'as a guest' do
      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, xhr: true
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe "POST #upvote" do
    
    context 'user can vote for the answer' do
      before do 
        login(other_user)
      end

      it 'increments the votable rating' do
        expect { post :vote_up, params: { id: answer.id } }.to change { answer.reload.rating }.by(1)
        expect(response).to have_http_status(:ok)
        expect(json_response['voted']).to be true
      end
    end

    context 'user cannot vote for the answer (e.g., voting for own answer)' do
      before do
        login(user)
        allow(user).to receive(:can_vote_for?).with(answer).and_return(false)
      end

      it 'does not increment the votable rating' do
        expect { post :vote_up, params: { id: answer.id } }.not_to(change { answer.reload.rating })
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to match(/can't vote for your own post or vote twice/)
      end
    end
  end

  describe "POST #downvote" do
    context 'when user can vote' do
      before do 
        login(other_user)
      end

      it 'decreases the answer rating' do
        allow(other_user).to receive(:can_vote_for?).with(answer).and_return(true)

        expect { post :vote_down, params: { id: answer.id } }
          .to change { answer.reload.rating }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response['rating']).to eq answer.rating
        expect(json_response['voted']).to be true
      end
    end

    context 'when user can not vote (e.g., owns the answer or already voted)' do
      before { login(user) }

      it 'does not change the answer rating and returns forbidden status' do
        allow(user).to receive(:can_vote_for?).and_return(false)

        expect { post :vote_down, params: { id: answer.id } }
          .not_to(change { answer.reload.rating })
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to eq "You can't vote for your own post or vote twice."
      end
    end
  end

  describe 'DELETE #unvote' do

    context 'when the user has voted' do
      before do
        login(other_user)
        answer.vote_up_by(other_user)
      end

      it 'removes the vote from votable object' do
        expect do
          delete :unvote, params: { id: answer }, format: :json
        end.to change(answer.votes, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response['voted']).to be false
      end
    end

    context 'when the user has not voted' do
      before { login(other_user) }
      it 'does not change vote count and returns not found status' do
        expect do
          delete :unvote, params: { id: answer }, format: :json
        end.not_to change(answer.votes, :count)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq("You haven't voted for this.")
      end
    end
  end
end
