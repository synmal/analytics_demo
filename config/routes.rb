Rails.application.routes.draw do
  root 'home#index'

  namespace :analytics do
    resources :sendgrid_single_sends, only: [:index, :show]
  end
end
