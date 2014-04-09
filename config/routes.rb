CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions, only: [:new, :show]
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]
  resources :levels, only: [:index]
  resources :languages, only: [:index]
  resources :roles, except: [:new]
  post '/roles/assign_role_to_user', to: 'roles#assign_role_to_user'
  post '/roles/remove_role_from_user', to: 'roles#remove_role_from_user'

  get '/auth/google/callback', to: 'omniauth_callbacks#google'

  get '/auth/development_token', to: 'omniauth_callbacks#development_token'
end
