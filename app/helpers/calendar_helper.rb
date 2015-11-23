module CalendarHelper
  def calendar_class_helper(date)
    class_names = []

    class_names << '-company-holiday' if CompanyHoliday.is_holiday?(date)
    class_names << '-employee-holiday' if current_employee.is_on_holiday?(date)
    class_names << '-sick-day' if current_employee.is_sick_day?(date)

    class_names.join(' ')
  end

  def any_employee_holidays_on_date?(date)
    Employee.all.each do |employee|
      employee.approved_holiday_requests.each do |request|
        request.employee_holidays.each do |holiday|
          return true if holiday.date == date
        end
      end
    end

    false
  end

  def any_birthdays_on_date?(date)
    Employee.all.each { |employee| return true if employee.is_birthday?(date) }

    false
  end
end
