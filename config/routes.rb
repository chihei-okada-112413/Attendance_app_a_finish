Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get '/sindex', to: 'users#sindex'
  
  # ログイン情報
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/overtime_application'
      patch 'attendances/update_overtime'
      get 'attendances/overtime_application_approval'
      patch 'attendances/update_overtime_approval'
      patch 'attendances/update_attendances_application'
      get 'attendances/attendances_application_approval'
      patch 'attendances/update_attendances_application_approval'
      patch 'attendances/update_attendances_change'
      get 'attendances/attendances_change_approval'
      patch 'attendances/update_attendances_change_approval'
      get 'attendances/attendances_change_history_log'
    end
    resources :attendances, only: [:update]
    collection { post :import }
  end

  resources :base_points
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
