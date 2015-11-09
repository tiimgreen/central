class CreateEmployeeHolidays < ActiveRecord::Migration
  def change
    create_table :employee_holidays do |t|
      t.integer :employee_id
      t.date :date

      t.timestamps
    end
  end
end
