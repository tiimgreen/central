class AddDateOfBirthToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :date_of_birth, :date
  end
end
