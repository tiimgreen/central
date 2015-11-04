class TimesController < ApplicationController
  before_action :authenticate_employee!
  before_action :validate_time, only: %i( edit_check_out edit_check_in )
  before_action :set_check_in, only: %i( edit_check_out edit_check_in )

  def index
    @week = Date.today.at_beginning_of_week..(Date.today.at_beginning_of_week + 4)
    @number_of_check_in_rows = current_employee.max_check_ins_this_week


    times = []

    @week.each_with_index do |day, i|
      times[i] = []

      current_employee.all_check_ins_on_date(day).each do |check_in|
        times[i].push(check_in)
      end
    end

    @check_in_out_times = times
  end

  def check_in_out_times
  end

  def edit_check_in
    check_in_date = Date.new(@check_in.check_in_time.year, @check_in.check_in_time.month, @check_in.check_in_time.day)
    new_time = check_in_date.to_datetime + Time.parse(user_entered_time).seconds_since_midnight.seconds

    if @check_in.update_attributes(check_in_time: new_time)
      flash[:success] = 'Time updated!'
    else
      flash[:danger] = 'Error updating time'
    end

    redirect_to root_path
  end

  def edit_check_out
    check_out_date = Date.new(@check_in.check_out_time.year, @check_in.check_out_time.month, @check_in.check_out_time.day)
    new_time = check_out_date.to_datetime + Time.parse(user_entered_time).seconds_since_midnight.seconds

    if @check_in.update_attributes(check_out_time: new_time)
      flash[:success] = 'Time updated!'
    else
      flash[:danger] = 'Error updating time'
    end

    redirect_to root_path
  end

  private

    # Ensures the user enters a valid 24hour format, time
    def validate_time
      user_entered_time = params[:check_in][:check_out_time]

      unless user_entered_time =~ /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
        flash[:danger] = 'That is not a valid time!'
        redirect_to root_path
      end
    end

    def set_check_in
      @check_in = CheckIn.find(params[:id])
    end
end
