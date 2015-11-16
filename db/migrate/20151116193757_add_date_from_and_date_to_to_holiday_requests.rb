class AddDateFromAndDateToToHolidayRequests < ActiveRecord::Migration
  def change
    add_column :holiday_requests, :date_from, :date
    add_column :holiday_requests, :date_to, :date
  end
end
