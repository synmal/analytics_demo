Rails.application.routes.draw do
  root 'home#index'

  namespace :analytics do
    resources :sendgrid_single_sends, only: [:index, :show]
    resources :facebook_page_posts, only: [:index]
  end
end
