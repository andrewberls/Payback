Payback::Application.routes.draw do

  resources :groups do
    get 'leave', :on => :member

    collection do
      get 'join'
      post 'add'
    end
  end

  resources :users do
    member do
      get 'debts'
      get 'credits'
    end
  end

  match 'signup'  => 'users#new',     as: 'signup'
  match 'welcome' => 'users#welcome', as: 'welcome'

  resources :expenses do
    get 'condensed', :on => :collection
  end
  match 'clear/:id' => 'expenses#clear', as: 'clear'

  namespace :notifications do
    post 'read'
  end

  resources :sessions, :only => [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: 'login'
  match 'logout' => 'sessions#destroy', as: 'logout'

  match 'start'     => 'static#start',     as: 'start'
  match 'not_found' => 'static#not_found', as: 'not_found'

  get 'contact'  => 'static#contact', as: 'contact'
  post 'contact' => 'static#mail',    as: 'contact'

  root :to => 'static#start'

  # Route page not found to 404 page
  match '*a' => 'static#not_found'

end
