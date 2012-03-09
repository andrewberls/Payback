Payback::Application.routes.draw do
  
  resources :groups
  resources :users
  resources :expenses
  resources :sessions, :only => [:new, :create, :destroy]

  match "welcome" => "static#welcome", as: "welcome"

  match "signup" => "users#new", as: "signup"

  match "login"  => "sessions#new", as: "login"
  match "logout" => "sessions#destroy", as: "logout"  

  root :to => "sessions#new", as: "login"

end
