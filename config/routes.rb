Rails.application.routes.draw do
  root 'home#index'

  namespace :analytics do
    resource :sendgrid, controller: 'sendgrid', only: :show
  end
end
