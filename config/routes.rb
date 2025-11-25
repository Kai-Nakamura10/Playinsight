Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "how_to", to: "pages#how_to"
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "contact", to: "pages#contact"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "static_pages#top"
  resources :users, only: %i[new create]
  resources :videos do
    resources :video_tags, only: %i[create destroy]
    resources :timelines, shallow: true, constraints: { format: :html } do
      collection do
        get :all, constraints: { format: :html }
      end
    end
    resources :comments, only: %i[create edit destroy], shallow: true
  end
  resources :video_tactics, only: [ :create, :update, :destroy ]
  resources :tags, only: %i[index show create destroy new]
  resources :bestselects, only: :show do
    post :answer, on: :member
  end
  resources :tactics
  resources :faqs
  resources :questions, only: [ :show ] do
    post :answer, on: :member
  end
  resources :rules do
    collection do
      get :search
    end
  end
end
