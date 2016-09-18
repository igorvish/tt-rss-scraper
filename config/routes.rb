Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'api/v0/rss_feeds#index'

  namespace :api do
    namespace :v0 do
      resources :rss_feeds, only: [:index] do
        get :search, on: :collection
      end
    end
  end

end
