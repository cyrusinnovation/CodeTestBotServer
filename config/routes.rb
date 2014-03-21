CodeTestBotServer::Application.routes.draw do
  resources :submissions, except: [:new, :edit]

  post '/auth/google/callback', to: 'users/omniauth_callbacks#google'
end
