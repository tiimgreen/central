class EmployeeHolidaysController < ApplicationController
  before_action :authenticate_employee!
  before_action :authenticate_line_manager!, only: :requests

  def index
    @holiday = EmployeeHoliday.new
  end

  def new
  end

  def create
    date_range = params[:employee_holiday][:date]

    if calculate_holidays_used(date_range) <= current_employee.remaining_holiday_days
      create_holidays(parse_date_range(date_range))
    end

    flash[:success] = "Holiday request sent, you're line manager will respond soon."
    redirect_to employee_holidays_path
  end

  private

    def parse_date_range(date_range)
      dates = date_range.split(' - ')

      start_date = Date.parse(dates[0])
      end_date = Date.parse(dates[1])

      (start_date..end_date).to_a
    end

    def create_holidays(date_range)
      request = current_employee.holiday_requests.create

      date_range.each do |date|
        if is_valid_date?(date)
          request.employee_holidays.create(date: date) if is_valid_date?(date)
        end
      end
    end

    def calculate_holidays_used(date_range)
      holidays_used = 0

      parse_date_range(date_range).each do |date|
        holidays_used += 1 if is_valid_date?(date)
      end

      holidays_used
    end

    def is_valid_date?(date)
      !date.saturday? && !date.sunday? && !CompanyHoliday.is_holiday?(date)
    end
end
