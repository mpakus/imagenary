Imagenary::Application.routes.draw do
  root 'photos#index'

  resources :about, only: [:index] do
    get :api, on: :collection
  end

  resources :users, only: [:index, :create, :destroy] do
    collection do
      post :auth
      get  :signup
      get  :signin
    end
  end

  resources :photos
end
