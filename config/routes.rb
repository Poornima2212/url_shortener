Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.test?
  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  # API Docs (swagger.json)
  mount Rswag::Api::Engine => '/api-docs'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :urls, only: [:index, :show, :new, :create]

  namespace :api do
    namespace :v1 do
      resources :urls, only: [:create]
    end
  end

  root "urls#index"
  get ':id', to: 'urls#show', as: 'shortened_url' 
end
