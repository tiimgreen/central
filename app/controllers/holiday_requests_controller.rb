class HolidayRequestsController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!

  def index
    @subordinates = current_employee.subordinates
  end

  def show
  end

  def approve
    @request = HolidayRequest.find(params[:id])

    if @request.update_attributes(
      authorised: true,
      authorised_by_id: current_employee.id)
      flash[:success] = "You have approved #{@request.employee.full_name}'s holiday!"
    else
      flash[:success] = "Error approving holiday."
    end

    redirect_to request.referrer
  end

  def decline
    @request = HolidayRequest.find(params[:id])
  end
end
