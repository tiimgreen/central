class HolidayRequestsController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!

  def index
    @subordinates = current_employee.subordinates
  end

  def show
  end

  def approve
  end

  def decline
  end
end
