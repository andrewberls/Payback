Payback::Application.routes.draw do
  
  resources :groups
  resources :users  

  match "login" => "users#edit" # TEMPORARY  

  root :to => "users#new" # TEMPORARY

end
