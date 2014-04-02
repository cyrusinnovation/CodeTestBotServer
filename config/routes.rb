CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]

  get 'levels', to: 'levels#index'
  get 'languages', to: 'languages#index'

  get '/auth/google/callback', to: 'users/omniauth_callbacks#google'
end
