class RenameLineManagerToIsLineManager < ActiveRecord::Migration
  def change
    rename_column :employees, :line_manager, :is_line_manager
  end
end
