require 'notes-cli/web'

Payback::Application.routes.draw do

  resources :groups do
    member do
      get 'leave'
      post 'invite'
    end

    collection do
      match 'join'
    end
  end

  get 'stats' => 'stats#stats', as: 'stats'
  resources :stats, only: [:index] do
    collection do
      get 'type_proportions' => 'stats#type_proportions'
      get 'segments'         => 'stats#segments'
    end
  end

  match 'invitations/:token' => "groups#invitations", as: 'invitations'

  resources :users do
    member do
      get 'debts'
      get 'credits'
    end
  end

  match 'signup'  => 'users#new',     as: 'signup'
  match 'welcome' => 'users#welcome', as: 'welcome'

  resources :expenses do
    collection do
      get 'tagged/:tag' => 'expenses#tagged', as: 'tagged'
      get 'new_v2' => 'expenses#new_v2' # TODO
    end
  end
  match 'clear/:id' => 'expenses#clear', as: 'clear'

  resources :notifications, only: [:new, :create] do
    post 'read', on: :collection
  end

  get 'cash' => 'static#cash', as: 'cash'

  resources :payments, only: [:index, :create] do
    get 'payments' => 'payments#index', as: 'payments'
  end

  resources :sessions, only: [:new, :create, :destroy]
  get 'login'    => 'sessions#new',     as: 'login'
  post 'login'   => 'sessions#create'
  match 'logout' => 'sessions#destroy', as: 'logout'

  get 'not_found' => 'static#not_found', as: 'not_found'

  get 'contact'  => 'static#contact', as: 'contact'
  post 'contact' => 'static#mail',    as: 'contact'

  match 'forgot_password'       => 'sessions#forgot_password', as: 'forgot_password'
  match 'reset_password/:token' => 'sessions#reset_password',  as: 'reset_password'

  root :to => 'static#main'

  # No reason putting this behind an auth gate, the project is
  # open-source anyways
  mount Notes::Web => '/notes'

  # Route page not found to 404 page
  match '*a' => 'static#not_found'

end
