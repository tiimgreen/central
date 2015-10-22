class CreateCheckIns < ActiveRecord::Migration
  def change
    create_table :check_ins do |t|
      t.integer :employee_id
      t.datetime :check_in_time
      t.datetime :check_out_time

      t.timestamps
    end
  end
end
