Payback::Application.routes.draw do
  
  resources :groups
  resources :users
  resources :sessions, :only => :create

  match "welcome" => "static#welcome", as: "welcome"

  match "signup" => "users#new", as: "signup"

  match "login"  => "sessions#new", as: "login"
  match "logout" => "sessions#destroy", as: "logout"  

  root :to => "expenses#list"

end
