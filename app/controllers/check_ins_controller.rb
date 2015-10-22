class CheckInsController < ApplicationController
  before_action :authenticate_employee!
  before_action :employee_checked_in?

  def check_in
    check_in = current_employee.check_ins.build(check_in_time: Time.now)

    if check_in.save
      flash[:success] = 'Checked in!'
    else
      flash[:warning] = 'There was an error checking you in.'
    end

    redirect_to root_path
  end

  def check_out
    check_in = current_employee.check_ins.order(created_at: :desc).first

    if check_in.update_attributes(check_out_time: Time.now)
      flash[:success] = 'Checked out!'
    else
      flash[:warning] = 'There was an error checking you in.'
    end

    redirect_to root_path
  end

  private

  def employee_checked_in?
    current_employee.checked_in?
  end
end
