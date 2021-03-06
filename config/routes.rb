Rails.application.routes.draw do

  devise_for :employees,
    path: '',
    path_names: { sign_in: 'login', sign_out: 'logout' }

  # Sets the 'index' action in the Times controller as the home page.
  root 'times#index'

  get 'week/:start_of_week', to: 'times#week', as: :calendar_week
  get 'sick-day/:date', to: 'times#mark_sick_day', as: :mark_sick_day

  post 'check-in', to: 'check_ins#check_in', as: :check_in
  post 'check-out', to: 'check_ins#check_out', as: :check_out

  resources :employees
  get 'employees/:id/:start_of_week', to: 'employees#week', as: :employee_calendar_week
  post 'employees/:id/deactivate-employee', to: 'employees#deactivate_employee', as: :deactivate_employee
  patch 'employees/:id/deactivate-employee', to: 'employees#deactivate_employee'

  resources :employee_holidays, path: 'holidays'

  resources :holiday_requests,  path: 'holiday-requests'
  get 'holiday-requests/:id/approve', to: 'holiday_requests#approve', as: :approve_holiday_request
  get 'holiday-requests/:id/decline', to: 'holiday_requests#decline', as: :decline_holiday_request

  resources :company_holidays, path: 'company-holidays'

  get 'calendar', to: 'calendar#index', as: :calendar
  get 'calendar/:date', to: 'calendar#month', as: :calendar_date

  # resources :times, only: %i(edit_check_in edit_check_out)
  patch 'times/:id/edit/check-in', to: 'times#edit_check_in', as: :edit_time_check_in
  patch 'times/:id/edit/check-out', to: 'times#edit_check_out', as: :edit_time_check_out
end
