class AddJobTitleToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :job_title, :string, default: ''
  end
end
