class AddAvatarToEmployees < ActiveRecord::Migration
  def up
    add_attachment :employees, :avatar
  end

  def down
    remove_attachment :employees, :avatar
  end
end
