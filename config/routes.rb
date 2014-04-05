CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions, only: [:new, :show]
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]
  resources :levels, only: [:index]
  resources :languages, only: [:index]

  get '/auth/google/callback', to: 'users/omniauth_callbacks#google'

  get '/auth/development_token', to: 'users/omniauth_callbacks#development_token'
end
