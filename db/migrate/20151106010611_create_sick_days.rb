class CreateSickDays < ActiveRecord::Migration
  def change
    create_table :sick_days do |t|
      t.date :date
      t.integer :employee_id
      t.text :notes

      t.timestamps
    end
  end
end
