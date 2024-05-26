# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voted do
  controller(ApplicationController) do
    include Voted
  end

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before do
    sign_in user
    allow(controller).to receive(:set_votable)
    allow(controller).to receive(:current_user).and_return(user)
    controller.instance_variable_set(:@votable, question)
  end

  describe 'POST #vote_up' do
    before { routes.draw { post 'vote_up' => 'anonymous#vote_up' } }

    context 'user can vote for the question' do
      it 'increments the votable rating' do
        expect { post :vote_up, params: { id: question.id } }.to change { question.reload.rating }.by(1)
        expect(response).to have_http_status(:ok)
        expect(json_response['voted']).to be true
      end
    end

    context 'user cannot vote for the question (e.g., voting for own question)' do
      before do
        allow(user).to receive(:can_vote_for?).with(question).and_return(false)
      end

      it 'does not increment the votable rating' do
        expect { post :vote_up, params: { id: question.id } }.not_to(change { question.reload.rating })
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to match(/can't vote for your own post or vote twice/)
      end
    end
  end

  describe 'POST #vote_down' do
    before { routes.draw { post 'vote_down' => 'anonymous#vote_down' } }

    context 'when user can vote' do
      it 'decreases the question rating' do
        allow(user).to receive(:can_vote_for?).with(question).and_return(true)

        expect { post :vote_down, params: { id: question.id } }
          .to change { question.reload.rating }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response['rating']).to eq question.rating
        expect(json_response['voted']).to be true
      end
    end

    context 'when user can not vote (e.g., owns the question or already voted)' do
      it 'does not change the question rating and returns forbidden status' do
        allow(user).to receive(:can_vote_for?).and_return(false)

        expect { post :vote_down, params: { id: question.id } }
          .not_to(change { question.reload.rating })
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to eq "You can't vote for your own post or vote twice."
      end
    end
  end

  describe 'DELETE #unvote' do
    before { routes.draw { post 'unvote' => 'anonymous#unvote' } }

    context 'when the user has voted' do
      before do
        question.vote_up_by(user)
      end

      it 'removes the vote from votable object' do
        expect do
          delete :unvote, params: { id: question }, format: :json
        end.to change(question.votes, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response['voted']).to be false
      end
    end

    context 'when the user has not voted' do
      it 'does not change vote count and returns not found status' do
        expect do
          delete :unvote, params: { id: question }, format: :json
        end.not_to change(question.votes, :count)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq("You haven't voted for this.")
      end
    end
  end
end
