Payback::Application.routes.draw do

  get "messages/index"

  get "messages/new"

  # Group actions
  resources :groups
  match 'join'              => 'groups#join',     as: 'join_group' # View
  match 'add'               => 'groups#add',      as: 'add_group'  # Processing
  match 'leave/:id'         => 'groups#leave',    as: 'leave_group'
  match 'messages/:gid'     => 'messages#index',  as: 'messages'
  post  'messages/:gid/new' => 'messages#new',    as: 'new_message'


  # User actions
  resources :users
  match 'signup'      => 'users#new',     as: 'signup'
  match 'welcome'     => 'users#welcome', as: 'welcome'
  match 'debts/:id'   => 'users#debts',   as: 'debts'
  match 'credits/:id' => 'users#credits', as: 'credits'


  # Expense actions
  resources :expenses
  # TODO: how to match expenses/condensed ?
  match 'condensed' => 'expenses#condensed', as: 'condensed'
  match 'clear/:id' => 'expenses#clear',     as: 'clear'


  # Session management
  resources :sessions, :only => [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: 'login'
  match 'logout' => 'sessions#destroy', as: 'logout'


  # Static pages
  match 'start'     => 'static#start',     as: 'start'
  match 'not_found' => 'static#not_found', as: 'not_found'
  get 'contact'     => 'static#contact',   as: 'contact'
  post 'contact'    => 'static#mail',      as: 'contact'


  root :to => 'static#start'

  # ROUTE ALL PAGE NOT FOUND TO 404 action
  match '*a' => 'static#not_found'

end
