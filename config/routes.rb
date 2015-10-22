Rails.application.routes.draw do
  devise_for :employees,
    path: '',
    path_names: { sign_in: 'login', sign_out: 'logout' }

  root 'times#index'

  match 'check-in', to: 'check_ins#check_in', as: :check_in, via: :post
  match 'check-out', to: 'check_ins#check_out', as: :check_out, via: :post

  resources :holidays, only: :index
  resources :employees, only: %i(index show edit)
end
