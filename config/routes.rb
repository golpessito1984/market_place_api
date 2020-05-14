# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :users, only: %i[show create destroy update]
      resources :tokens, only: %i[create]
    end
  end
end
