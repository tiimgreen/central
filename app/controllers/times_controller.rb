class TimesController < ApplicationController
  before_action :authenticate_employee!

  def index
    @week = Date.today.at_beginning_of_week..(Date.today.at_beginning_of_week + 4)
    @number_of_check_in_rows = current_employee.max_check_ins_this_week * 2


    times = []

    @week.each_with_index do |day, i|
      times[i] = []

      current_employee.all_check_ins_on_date(day).each do |check_in|
        times[i].push(check_in.check_in_time.strftime('%k:%M'))
        if check_in.check_out_time
          times[i].push(check_in.check_out_time.strftime('%k:%M'))
        end
      end
    end

    @check_in_out_times = times
  end

  def check_in_out_times
  end
end
