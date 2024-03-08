Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    omniauth_callbacks: 'public/omniauth_callbacks' #SNS認証用に追記
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  root to: 'public/homes#top'

  scope module: :public do
    resources :drive_diaries
    resources :customers
    resources :roads
  end

  namespace :admin do
    resources :roads
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
