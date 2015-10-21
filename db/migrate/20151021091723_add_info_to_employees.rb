class AddInfoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_column :employees, :address_line_1, :string
    add_column :employees, :address_line_2, :string
    add_column :employees, :post_code, :string
  end
end
