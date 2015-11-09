class CreateHolidayRequests < ActiveRecord::Migration
  def change
    create_table :holiday_requests do |t|
      t.integer :employee_id
      t.boolean :authorised,       default: false
      t.integer :authorised_by_id

      t.timestamps
    end
  end
end
