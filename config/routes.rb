TrainingGrant::Application.routes.draw do

  mount MailPreview => 'mail_view' if Rails.env.development?

  resources :annuals do
    member do
      get :edit_me
      put :update_me
    end
  end

  # devise_for :applicants, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords' }, path_names: { sign_up: 'register', sign_in: 'login' }
  devise_for :applicants, path: 'as', path_names: { sign_up: 'register', sign_in: 'login' }

  resources :applicants do
    collection do
      get :dashboard
      get :edit_me
      put :update_me
      get :exit_interview
      post :update_exit_interview
      post :add_degree
    end
    member do
      post :email
      get :annual_email
      post :termination_email
      post :unlock
      post :update_submitted_at_date
      post :help_email
    end
  end

  devise_for :preceptors, path: 'ps', path_names: { sign_up: 'register', sign_in: 'login' }

  resources :preceptors do
    collection do
      get :dashboard
      get :edit_me
      put :update_me
    end
    member do
      post :email
    end
  end

  resources :seminars do
    collection do
      get :attendance
    end
    member do
      post :attended
    end
  end

  devise_for :users, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords', confirmations: 'contour/confirmations', unlocks: 'contour/unlocks' }, path_names: { sign_up: 'register', sign_in: 'login' }

  resources :users

  get "/about" => "application#about", as: :about
  get "/settings" => "users#settings", as: :settings
  get "/dashboard" => "sites#dashboard", as: :dashboard

  root to: 'sites#dashboard'

end
