Rails.application.routes.draw do
  resources :achievements, only: [ :new, :create, :show ]
  root to: 'welcome#index'
end
