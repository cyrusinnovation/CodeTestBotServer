CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions, only: [:new, :show]
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]
  resources :levels, only: [:index]
  resources :languages, only: [:index]
  resources :roles, except: [:new]
  post '/roles/assign_role_to_user', to: 'roles#assign_role_to_user'

  get '/auth/google/callback', to: 'users/omniauth_callbacks#google'
end
