Payback::Application.routes.draw do

  # Resource matching
  resources :groups
  resources :users
  resources :expenses
  resources :sessions, :only => [:new, :create, :destroy]


  # Static pages
  match "welcome" => "static#welcome", as: "welcome"


  # Group init
  match "join" => "groups#join", as: "join_group" # View
  match "add"  => "groups#add", as: "add_group" # Processing


  # User processing
  match "signup" => "users#new", as: "signup"


  # Session management
  match "login"  => "sessions#new", as: "login"
  match "logout" => "sessions#destroy", as: "logout"  

  root :to => "sessions#new"

end
