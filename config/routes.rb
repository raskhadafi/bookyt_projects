Rails.application.routes.draw do
  resources :projects do
    resources :tasks
  end
  resources :project_states
  resources :tasks
end