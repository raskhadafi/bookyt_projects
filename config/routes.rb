Rails.application.routes.draw do
  resources :projects do
    resources :activities
  end
  resources :project_states
  resources :activities
end