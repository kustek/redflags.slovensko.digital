require 'que/web'

Que::Web.use(Rack::Auth::Basic) do |username, password|
  username == ENV.fetch('ADMIN_USER') && password == ENV.fetch('ADMIN_PASSWORD')
end

Rails.application.routes.draw do
  resources :projects, path: 'projekty'

  namespace :admin do
    root to: 'pages#index'

    resources :pages do
      patch :publish, on: :member
      patch :unpublish, on: :member

      put :sync, on: :collection
    end

    mount Que::Web, at: 'que'
  end

  get 'o-projekte', as: 'about', to: 'static#about'
  get 'ako-hodnotime', as: 'about_rating', to: 'static#about_rating'
  get 'ako-sa-zapojit', as: 'contribute', to: 'static#contribute'
  get 'casto-kladene-otazky', as: 'faq', to: 'static#faq'

  root to: 'static#index'
end
