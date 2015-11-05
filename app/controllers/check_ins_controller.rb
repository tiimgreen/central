class CheckInsController < ApplicationController
  before_action :authenticate_employee!
  before_action :employee_checked_in?, only: :check_out

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
    check_in = current_employee.check_ins.order(:check_in_time).last

    # If the user is checking out a day after they checked in, they must have
    # forgotten to check out so it changes check-out time to the end of the day.
    if Time.at(Time.now).to_date === Time.at(check_in.check_in_time).to_date
      check_out_time = Time.now
    else
      check_out_time = Time.at(check_in.check_in_time).to_date.end_of_day
    end

    if check_in.update_attributes(check_out_time: check_out_time)
      flash[:success] = 'Checked out!'
    else
      flash[:warning] = 'There was an error checking you in.'
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
