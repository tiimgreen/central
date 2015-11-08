class EmployeesController < ApplicationController
  before_action :authenticate_line_manager!

  def index
    @employees = Employee.all
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit
  end
end
