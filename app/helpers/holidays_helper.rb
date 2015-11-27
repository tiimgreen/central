module HolidaysHelper

  def parse_date_range(date_range)
    dates = date_range.split(' - ')

    start_date = Date.parse(dates[0])
    end_date = Date.parse(dates[1])

    return [start_date] if start_date == end_date

    (start_date..end_date).to_a
  end

  def is_weekend?(date)
    date.saturday? || date.sunday?
  end

  def is_company_holiday?(date)
    CompanyHoliday.is_holiday?(date)
  end

  def will_be_understaffed?(employee, date)
    max_line_managers_off = 2
    max_subordinates_off = 3

    colleagues = Employee.where(is_line_manager: employee.is_line_manager)
    employees_off = 0

    colleagues.each do |colleague|
      colleague.holiday_requests.each do |request|
        holidays = request.employee_holidays.where(date: date)
        employees_off += holidays.count
      end
      # holidays = EmployeeHoliday.where(employee_id: colleague.id, date: date)
      # employees_off += holidays.count
    end

    if employee.is_line_manager
      return max_line_managers_off - employees_off <= 0
    else
      return max_subordinates_off - employees_off <= 0
    end
  end
end
