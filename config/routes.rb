Adhoq::Engine.routes.draw do
  root to: 'queries#new'

  resources :hidden_tables
  resources :queries, path: 'q', only: %w[create edit show index update destroy] do
    resources :executions, only: %w[create show]
  end

  resource  :preview,        only: 'create'
  resource  :explain,        only: 'create'
  resources :current_tables, only: 'index'
end
