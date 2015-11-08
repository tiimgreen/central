class AddLineManagerIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :line_manager_id, :integer
  end
end
