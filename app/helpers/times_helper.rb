module TimesHelper
  def can_mark_as_sick_day(day)
    Date.today >= day &&
    !current_employee.sick_day?(day) &&
    !current_employee.all_check_ins_on_date(day).any?
  end
end
