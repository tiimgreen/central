class AddHolidayRequestIdToEmployeeHolidays < ActiveRecord::Migration
  def change
    add_column :employee_holidays, :holiday_request_id, :integer
  end
end
