CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions
  resources :submissions, except: [:new, :edit]

  get '/auth/google/callback', to: 'users/omniauth_callbacks#google'
end
