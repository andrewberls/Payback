Payback::Application.routes.draw do
  
  resources :users

  match "login" => "users#edit"

  root :to => 'users#new'

end
