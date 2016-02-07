class EmployeeHolidaysController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!, only: :requests

  def index
    @holiday = EmployeeHoliday.new
    @company_holidays = CompanyHoliday.where(
      "date >= ?", Date.today
    ).order(:date)
    @pending_employee_holidays = current_employee.pending_holiday_requests.where(
      "date_to >= ?", Date.today
    ).order(:date_to)
    @approved_employee_holidays = current_employee.approved_holiday_requests.where(
      "date_to >= ?", Date.today
    ).order(:date_to)
    @declined_employee_holidays = current_employee.declined_holiday_requests.where(
      "date_to >= ?", Date.today
    ).order(:date_to)
  end

  def new
  end

  def create
    date_range = params[:employee_holiday][:date]

    if current_employee.has_enough_holiday_left?(date_range)
      create_holiday_requests(parse_date_range(date_range))
    else
      flash[:danger] = 'You do not have enough holidays to do that.'
    end

    redirect_to employee_holidays_path
  end

  private

    def create_holiday_requests(date_range)
      request = current_employee.holiday_requests.build(
        date_from: date_range.first,
        date_to: date_range.last
      )

      if request.save
        flash[:success] = "Holiday request sent, you're line manager will respond soon."

        # If current_employee is a line manager, approve the request by default,
        # so long as there is no more than 2 other line managers away
        if current_employee.is_line_manager
          request.approve_by(current_employee)
          flash[:success] = 'Holiday approved!'
        end
      else
        flash[:danger] = request.errors.full_messages.first
      end
    end
end
