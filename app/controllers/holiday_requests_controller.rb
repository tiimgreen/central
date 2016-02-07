class HolidayRequestsController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!, except: :show

  def index
    @subordinates = current_employee.subordinates
  end

  def show
    @holiday_request = HolidayRequest.find(params[:id])
  end

  def approve
    @holiday_request = HolidayRequest.find(params[:id])

    if @holiday_request.approve_by(current_employee)
      flash[:success] = "You have approved #{@holiday_request.employee.full_name}'s holiday!"
    else
      flash[:warning] = 'Error approving holiday.'
    end

    redirect_to request.referrer
  end

  def decline
    @holiday_request = HolidayRequest.find(params[:id])

    if @holiday_request.decline_by(current_employee)
      flash[:success] = "You have declined #{@holiday_request.employee.full_name}'s holiday."
    else
      flash[:warning] = 'Error declining holiday.'
    end

    redirect_to request.referrer
  end
end
