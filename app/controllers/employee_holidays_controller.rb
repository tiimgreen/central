class EmployeeHolidaysController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!, only: :requests

  def index
    @holiday = EmployeeHoliday.new
    @company_holidays = CompanyHoliday.all.order(:date)
  end

  def new
  end

  def create
    date_range = params[:employee_holiday][:date]

    if current_employee.has_enough_holiday_left?(date_range)
      create_holidays(parse_date_range(date_range))
    end

    flash[:success] = "Holiday request sent, you're line manager will respond soon."
    redirect_to employee_holidays_path
  end

  private

    def create_holidays(date_range)
      request = current_employee.holiday_requests.create

      date_range.each do |date|
        request.employee_holidays.create(date: date) if current_employee.is_allowed_date_off?(date)
      end

      # If current_employee is a line manager, approve the request by default,
      # so long as there is no more than 2 other line managers away
      if current_employee.is_line_manager
        request.update_attributes(authorised: true, authorised_by_id: current_employee.id)
      end
    end
end
