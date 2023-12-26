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
    resources :chats
    resources :subscriptions, only: %i[create index]
    get :payment_methods, to: "subsciptions#list_payment_methods"

    post "stripe/webhooks", to: "webhooks#create"
    # stripe listen --forward-to localhost:3000/user/stripe/webhooks
  end
end
