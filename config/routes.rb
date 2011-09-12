Rails.application.routes.draw do
  resources :projects
  resources :project_states
  resources :tasks
end