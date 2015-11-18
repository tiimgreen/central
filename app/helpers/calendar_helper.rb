module CalendarHelper
  def class_helper(date)
    class_names = []

    class_names << '-company-holiday' if CompanyHoliday.is_holiday?(date)
    class_names << '-employee-holiday' if current_employee.is_on_holiday?(date)
    class_names << '-sick-day' if current_employee.sick_day?(date)

    class_names.join(' ')
  end
end
