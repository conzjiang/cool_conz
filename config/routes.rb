Rails.application.routes.draw do
  resources :comments

  namespace :api do
    resources :comments
  end

  root to: "comments#index"
end
