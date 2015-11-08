class AddDefaultValueToActive < ActiveRecord::Migration
  def change
    change_column :employees, :active, :boolean, default: true
  end
end
