NinetyNineCats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests

  post "/cat_rental_requests/:id/approve", to: "cat_rental_requests#approve", as: "approve_cat_rental_request"
  post "/cat_rental_requests/:id/deny", to: "cat_rental_requests#deny", as: "deny_cat_rental_request"
  post "/cat_rental_requests/:id/pending_all", to: "cat_rental_requests#pending_all", as: "pending_all_cat_rental_request"

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

end
