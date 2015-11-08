class EmployeesController < ApplicationController
  before_action :authenticate_line_manager!

  def index
    @employees = Employee.all
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
    @potential_line_manager = Employee.where(active: true, line_manager: true)
  end

  def create
  end

  def edit
  end

  def update
  end
end
