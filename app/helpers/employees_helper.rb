module EmployeesHelper
  def user_card_class_helper(employee)
    'deactivated' unless employee.is_active?
  end
end
