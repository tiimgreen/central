class AddAuthorisedFieldsToEmployeeHolidays < ActiveRecord::Migration
  def change
    add_column :employee_holidays, :authorised, :boolean
    add_column :employee_holidays, :authorised_by_id, :integer
  end
end
