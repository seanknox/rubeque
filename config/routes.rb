Rubeque::Application.routes.draw do
  resources :following, only: [:create, :destroy]

  resources :votes

  resources :users, only: :index

  resources :problems do
    get 'unapproved', on: :collection
    put 'approve', on: :member
    get 'rss', on: :collection

    resources :solutions, except: [:new] do
      get "share", on: :collection
      get "report", on: :member
    end
  end

  resources :audits

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

  get "static/index"
  match 'help' => 'static#help', :via => :get, :as => :help
  match 'problem_submission' => "static#problem_submission", via: :get, as: "submission_help"
  match "admin" => "static#admin", as: "admin"
  match "ad" => "static#ad", as: "ad"

  get "cheating", as: :cheating, controller: :cheating, action: :index


  root to: "static#home"
end
