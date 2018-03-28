require 'api_version_constraint'

Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/'  do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :schedules, only: [:index, :show, :create, :update, :destroy]
      resources :appointments, only: [:index, :show, :create, :update, :destroy]
    end
  end

end