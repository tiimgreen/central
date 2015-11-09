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
    @potential_line_manager = Employee.where(active: true, is_line_manager: true)
  end

  def create
    @employee = Employee.new(employee_params.merge({ password: 'password' }))
    @potential_line_manager = Employee.where(active: true, line_manager: true)

    if @employee.save
      flash[:success] = 'Employee saved!'
      redirect_to @employee
    else
      flash[:danger] = 'Error saving employee'
      render :new
    end
  end

  def edit
  end

  def update
  end

  def deactivate_employee
    employee = Employee.find(params[:id])
    end_date = Date.parse(params[:employee][:date])

    if employee.update_attributes(active: false, end_date: end_date)
      flash[:success] = 'Employee Deactivated'
    else
      flash[:danger] = 'Error deactivating employee'
    end

    redirect_to employee
  end

  private

    def employee_params
      params.require(:employee).permit(:email, :first_name, :last_name,
        :address_line_1, :address_line_2, :post_code, :contracted_hours,
        :line_manager_id, :start_date, :job_title, :line_manager,
        :emergency_contact_name, :emergency_contact_relation,
        :emergency_contact_phone_number, :emergency_contact_phone_number_2)
    end
end
