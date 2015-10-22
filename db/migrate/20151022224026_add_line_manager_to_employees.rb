class AddLineManagerToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :line_manager, :boolean, default: false
  end
end
