# frozen_string_literal: true

Rails.application.routes.draw do
  apipie
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  resources :users
  namespace :api do
    namespace :femida do
      resources :inn,     only: :show
      resources :debtors, only: :show
      resources :fsin,    only: :show
      resources :nalog,   only: :show
      resources :egrul,   only: :show
      resources :arbitr,  only: :show
      resources :npd,     only: :show
      resources :bankrot, only: :show
      resources :rkn,     only: [:index, :show]
      resources :driver,  only: :index
      resources :sro,     only: :index
      resources :whoosh,  only: :index
      resources :websbor, only: :index
      resources :bonalog, only: :index
      resources :esia,    only: :index do
        collection do
          get :passport
          get :phone
          get :email
          get :inn
          get :snils
        end
      end
    end
  end
end
