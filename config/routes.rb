Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resource :public_chats, only: %i[show update]

  scope :user do
    patch 'update_password', to: 'users#update_password'
    patch 'update_info', to: 'users#update_without_password'
    delete 'deactivate', to: 'users#deactivate'
    resources :chats
    # resources :subscriptions, only: %i[create index]
    post :create_checkout_session, to: "subscriptions#create"
    get :checkout_session_status, to: "subscriptions#show"
    get :invoices, to: "subscriptions#index"
    get :payment_methods, to: "subsciptions#list_payment_methods"

    # stripe listen --forward-to localhost:3000/user/stripe/webhooks
  end
end
