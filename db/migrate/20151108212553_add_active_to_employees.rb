class AddActiveToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :end_date, :date
    add_column :employees, :active, :boolean
    add_column :employees, :contracted_hours, :float
    add_column :employees, :emergency_contact_name, :string
    add_column :employees, :emergency_contact_relation, :string
    add_column :employees, :emergency_contact_phone_number, :string
    add_column :employees, :emergency_contact_phone_number_2, :string
  end
end
