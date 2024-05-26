# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user:) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user:) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested question to @question' do
      get :show, params: { id: question }
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns a new answer to @answer' do
      get :show, params: { id: question }
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link to @answer' do
      get :show, params: { id: question }
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders the show template' do
      get :show, params: { id: question }
      expect(response).to render_template(:show)
    end

    it 'does not require authentication' do
      get :show, params: { id: question }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assings a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assings a new link in Question to @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      login(user)
      get :edit, params: { id: question }
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to have_content 'Question №'
        expect(question.body).to have_content 'Body for question №'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user:) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe "POST #upvote" do
    
    context 'user can vote for the question' do
      before { login(other_user) } 

      it 'increments the votable rating' do
        expect { post :vote_up, params: { id: question.id } }.to change { question.reload.rating }.by(1)
        expect(response).to have_http_status(:ok)
        expect(json_response['voted']).to be true
      end
    end

    context 'user cannot vote for the question (e.g., voting for own question)' do
      before do
        login(user)
        allow(user).to receive(:can_vote_for?).with(question).and_return(false)
      end

      it 'does not increment the votable rating' do
        expect { post :vote_up, params: { id: question.id } }.not_to(change { question.reload.rating })
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to match(/can't vote for your own post or vote twice/)
      end
    end
  end

  describe "POST #downvote" do
    context 'when user can vote' do
      before { login(other_user) }

      it 'decreases the question rating' do
        allow(other_user).to receive(:can_vote_for?).with(question).and_return(true)

        expect { post :vote_down, params: { id: question.id } }
          .to change { question.reload.rating }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response['rating']).to eq question.rating
        expect(json_response['voted']).to be true
      end
    end

    context 'when user can not vote (e.g., owns the question or already voted)' do
      before { login(user) }

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

    context 'when the user has voted' do
      before do
        login(other_user)
        question.vote_up_by(other_user)
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
      before { login(user) }
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
