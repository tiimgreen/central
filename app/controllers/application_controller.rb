class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :address_line_1,
        :address_line_2, :post_code, :job_title, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :first_name, :last_name, :address_line_1,
        :address_line_2, :post_code, :job_title, :password, :password_confirmation,
        :current_password)
    end
  end

  def authenticate_line_manager!
    unless current_employee.line_manager
      flash[:warning] = 'You do not have the correct access to do this.'
      redirect_to root_path
    end
  end
end
