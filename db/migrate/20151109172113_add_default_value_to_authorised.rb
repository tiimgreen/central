class AddDefaultValueToAuthorised < ActiveRecord::Migration
  def change
    change_column :employee_holidays, :authorised, :boolean, default: false
  end
end
