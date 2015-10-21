Rails.application.routes.draw do
  devise_for :employees
  root 'times#index'
end
