class CheckInsController < ApplicationController
  before_action :authenticate_employee!
  before_action :employee_checked_in?, only: :check_out

  def check_in
    if current_employee.check_in
      flash[:success] = 'Checked in!'
    else
      flash[:warning] = 'There was an error checking you in.'
    end

    redirect_to root_path
  end

  def check_out
    if current_employee.check_out
      flash[:success] = 'Checked out!'
    else
      flash[:warning] = 'There was an error checking you out.'
    end

    redirect_to root_path
  end

  private

  def employee_checked_in?
    unless current_employee.checked_in?
      flash[:danger] = "You can't check out if you're not checked in"
      redirect_to root_path
    end
  end
end
