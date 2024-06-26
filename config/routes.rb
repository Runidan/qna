# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, except: %i[new show]
    member do
      post :set_best_answer
    end
  end
  resources :users, only: [:show]
  resources :files, only: [:destroy]

  root to: 'questions#index'
end
