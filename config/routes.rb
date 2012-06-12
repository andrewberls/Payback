Payback::Application.routes.draw do

  # Resource matching
  resources :groups
  resources :users
  resources :expenses
  resources :sessions, :only => [:new, :create, :destroy]

  # Group actions
  match "join"  => "groups#join",  as: "join_group" # View
  match "add"   => "groups#add",   as: "add_group"  # Processing
  match "leave" => "groups#leave", as: "leave_group"


  # User actions
  match "signup" => "users#new",      as: "signup"
  match "welcome" => "users#welcome", as: "welcome"


  # Session management
  match "login"  => "sessions#new",     as: "login"
  match "logout" => "sessions#destroy", as: "logout"


  # Static pages
  match "start"     => "static#start", as: "start"
  match "not_found" => "static#not_found", as: "not_found"

  get 'contact'  => 'static#contact', as: 'contact'
  post 'contact' => 'static#mail', as: 'contact'


  root :to => "static#start"


  # ROUTE ALL PAGE NOT FOUND TO 404 action
  match "*a" => "static#not_found"
  #match "*a" => redirect("/")

end
