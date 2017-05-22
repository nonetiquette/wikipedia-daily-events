Rails.application.routes.draw do

  root 'events#index'

  resources :events, only: :index, defaults: { format: :html }

  namespace :api do
    namespace :v1 do
      resources :wikipedia_dates,
                only: [:index, :show],
                param: :occurrence_date_permalink,
                defaults: { format: :json } do
        resources :wikipedia_events, only: :index, defaults: { format: :json }
      end
    end
  end
end
