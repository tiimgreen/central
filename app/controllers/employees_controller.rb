class EmployeesController < ApplicationController
  before_action :authenticate_line_manager!

  def index
    @employees = Employee.all
  end

  def view
  end

  def edit
  end
end
