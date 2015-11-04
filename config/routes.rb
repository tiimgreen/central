Rails.application.routes.draw do
  devise_for :employees,
    path: '',
    path_names: { sign_in: 'login', sign_out: 'logout' }

  # Sets the 'index' action in the Times controller as the home page.
  root 'times#index'

  post 'check-in', to: 'check_ins#check_in', as: :check_in
  post 'check-out', to: 'check_ins#check_out', as: :check_out

  resources :holidays, only: :index
  resources :employees, only: %i(index show edit)

  # resources :times, only: %i(edit_check_in edit_check_out)
  patch 'times/:id/edit/check-in', to: 'times#edit_check_in', as: :edit_time_check_in
  patch 'times/:id/edit/check-out', to: 'times#edit_check_out', as: :edit_time_check_out
end
