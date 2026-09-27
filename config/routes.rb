Rails.application.routes.draw do
  root "pages#home"
  get "about", to: "pages#about", as: :about
  get "design", to: "pages#design", as: :design

  resources :subscribers, only: :create

  get "feed", to: "feed#index", as: :feed
  resources :circles, only: :show, param: :slug

  resources :categories, only: %i[index show], param: :slug
  resources :posts, only: %i[index show], param: :slug

  namespace :admin do
    root "dashboard#show"
    resources :categories, except: :show
    resources :posts, except: :show
    resources :subscribers, only: %i[index destroy]
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :categories, only: %i[index show], param: :slug
      resources :posts, only: %i[index show], param: :slug
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
