class CalendarController < ApplicationController
  before_action :authenticate_employee!

  def index
    set_variables(Date.today.month, Date.today.year)
  end

  def month
    date = Date.parse(params[:date])
    set_variables(date.month, date.year)

    render :index
  end

  def set_variables(month, year)
    @month = month
    @year = year

    @start_of_month = Date.parse("#{year}-#{month}-1")
    @days_in_month = Time.days_in_month(@month, @year)

    @dates = [[]]

    # Add blank dates before 1st of month
    blank_spaces_at_start_of_cal(@start_of_month.wday).times { @dates[0] << nil }

    @days_in_month.times do |date_in_month|
      date_in_month = date_in_month + 1

      row = (date_in_month + day_of_week(@start_of_month.wday) - 1) / 7
      row -= 1 if day_of_week(@start_of_month.wday) == 7 && (date_in_month + 6) % 7 == 0

      @dates[row] = [] unless @dates[row]
      @dates[row] << date_in_month
    end

    if @dates.last.length < 7
      (7 - @dates.last.length).times do |n|
        @dates.last << nil
      end
    end
  end

  private

    def blank_spaces_at_start_of_cal(day)
      return 6 if day == 0
      day - 1
    end

    def day_of_week(day)
      return 7 if day == 0
      day - 1
    end
end
