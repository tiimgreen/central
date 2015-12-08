module CalendarHelper
  def calendar_class_helper(date)
    class_names = []

    class_names << '-today' if date == Date.today
    class_names << '-payday' if date.day == 25

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

  def any_sick_days_on_date?(date)
    Employee.all.each { |employee| return true if employee.is_sick_day?(date) }

    false
  end
end
