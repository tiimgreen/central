class CreateCompanyHolidays < ActiveRecord::Migration
  def change
    create_table :company_holidays do |t|
      t.date :date

      t.timestamps
    end
  end
end
