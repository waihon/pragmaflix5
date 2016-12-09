Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
  root "movies#index"
  resources :movies do
    resources :reviews
    member do
      post "create_review"
    end
  end
end
