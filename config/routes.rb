Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :secrets, only: %i[create show destroy] do
    member do
      get :created
    end
  end

  # Defines the root path route ("/")
  root 'landing#index'
end
