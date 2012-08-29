Payback::Application.routes.draw do

  # Group actions
  resources :groups do
    get 'leave', :on => :member

    collection do
      get 'join'
      post 'add'
    end
  end


  # User actions
  resources :users do
    member do
      get 'debts'
      get 'credits'
    end
  end

  match 'signup'      => 'users#new',     as: 'signup'
  match 'welcome'     => 'users#welcome', as: 'welcome'


  # Expense actions
  resources :expenses do
    get 'condensed', :on => :collection
  end

  match 'clear/:id' => 'expenses#clear', as: 'clear'


  # Session management
  resources :sessions, :only => [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: 'login'
  match 'logout' => 'sessions#destroy', as: 'logout'


  # Static pages
  match 'start'     => 'static#start',     as: 'start'
  match 'not_found' => 'static#not_found', as: 'not_found'

  get 'contact'  => 'static#contact', as: 'contact'
  post 'contact' => 'static#mail',    as: 'contact'


  root :to => 'static#start'


  # Route page not found to 404 page
  match '*a' => 'static#not_found'

end
