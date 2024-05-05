# frozen_string_literal: true

Rails.application.routes.draw do

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :unvote
    end
  end

  devise_for :users
  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, except: %i[new show]
    member do
      post :set_best_answer
    end
  end

  resources :answers, concerns: [:votable]

  resources :users, only: [:show]
  resources :files, only: [:destroy]

  root to: 'questions#index'
end
