class TimesController < ApplicationController
  before_action :authenticate_employee!
  before_action :validate_check_in_time, only: :edit_check_in
  before_action :validate_check_out_time, only: :edit_check_out
  before_action :set_check_in, only: %i( edit_check_out edit_check_in )

  def index
    # Gets a range of dates from Monday to Friday in current week
    @week = Date.today.at_beginning_of_week..(Date.today.at_beginning_of_week + 4)

    @check_in_out_times = []

    @week.each_with_index do |day, i|
      @check_in_out_times[i] = []

      current_employee.all_check_ins_on_date(day).each do |check_in|
        @check_in_out_times[i].push(check_in)
      end
    end
  end

  def check_in_out_times
  end

  def edit_check_in
    check_in_date = Date.new(
      @check_in.check_in_time.year,
      @check_in.check_in_time.month,
      @check_in.check_in_time.day
    )

    additional_seconds = Time.parse(params[:check_in][:check_in_time]).seconds_since_midnight.seconds
    new_time = check_in_date.to_datetime + additional_seconds

    if @check_in.update_attributes(check_in_time: new_time)
      flash[:success] = 'Time updated!'
    else
      flash[:danger] = 'Error updating time'
    end

    redirect_to root_path
  end

  def edit_check_out
    check_out_date = Date.new(
      @check_in.check_out_time.year,
      @check_in.check_out_time.month,
      @check_in.check_out_time.day
    )

    additional_seconds = Time.parse(params[:check_in][:check_out_time]).seconds_since_midnight.seconds
    new_time = check_out_date.to_datetime + additional_seconds

    if @check_in.update_attributes(check_out_time: new_time)
      flash[:success] = 'Time updated!'
    else
      flash[:danger] = 'Error updating time'
    end

    redirect_to root_path
  end

  private

    # Ensures the user enters a valid 24hour format, time
    def validate_check_in_time
      validate_time(params[:check_in][:check_in_time])
    end

    def validate_check_out_time
      validate_time(params[:check_in][:check_out_time])
    end

    def validate_time(user_entered_time)
      unless user_entered_time =~ /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
        flash[:danger] = 'That is not a valid time!'
        redirect_to root_path
      end
    end

    def set_check_in
      @check_in = CheckIn.find(params[:id])
    end
end
