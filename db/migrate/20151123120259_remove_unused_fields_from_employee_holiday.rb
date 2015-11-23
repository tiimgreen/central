class RemoveUnusedFieldsFromEmployeeHoliday < ActiveRecord::Migration
  def change
    remove_column :employee_holidays, :employee_id
    remove_column :employee_holidays, :authorised
    remove_column :employee_holidays, :authorised_by_id
  end
end
