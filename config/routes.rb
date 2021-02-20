Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  require 'resque/server'
  mount Resque::Server, at: '/admin/jobs'

  resources :short_urls, only: [:create]

  get 's/:id', to: 'short_urls#redirect_url'
  get '/', to: 'short_urls#top_url'
  post 'find_short_url', to: 'short_urls#find_short_url'
end
