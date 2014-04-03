CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions, only: [:new, :show]
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]

  resource :level, only: [:show]
  resource :language, only: [:show]

  get '/auth/google/callback', to: 'users/omniauth_callbacks#google'
end
