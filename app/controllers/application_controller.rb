class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper

  protected

  def configure_permitted_parameters
    # Alters the parameters that can be passed to devise when the user signs up
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :address_line_1,
        :address_line_2, :post_code, :job_title, :password,
        :password_confirmation, :date_of_birth)
    end

    # Alters the parameters that can be passed to devise when the user edits
    # their account
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :first_name, :last_name, :address_line_1,
        :address_line_2, :post_code, :job_title, :password, :password_confirmation,
        :current_password, :emergency_contact_name, :emergency_contact_relation,
        :emergency_contact_phone_number, :emergency_contact_phone_number_2,
        :date_of_birth, :avatar)
    end
  end

  def authenticate_line_manager!
    unless current_employee.is_line_manager
      flash[:warning] = 'You do not have the correct access to do this.'
      redirect_to root_path
    end
  end

  # Sets the variables the user needs in order for the check-in/check-out table
  # on the current page to work
  #
  # @param (Employee) - the employee to fetch the check in times for
  def set_week_variables(employee)
    start_date = params[:start_of_week] || Date.today.at_beginning_of_week
    @start_of_week = Date.parse(start_date.to_s)
    @end_of_week = @start_of_week + 4.days
    @week = @start_of_week..(@start_of_week + 4)

    @check_in_out_times = employee.check_in_out_times(@week)
  end
end
