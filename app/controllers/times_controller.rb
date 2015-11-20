class TimesController < ApplicationController
  before_action :authenticate_employee!
  before_action :validate_check_in_time, only: :edit_check_in
  before_action :validate_check_out_time, only: :edit_check_out
  before_action :set_check_in, only: %i( edit_check_out edit_check_in )
  before_action :set_week_variables, only: %i( index week )
  before_action :validate_is_start_of_week, only: :week

  def index
  end

  def week
    # renders the view for index so I don't need to create another view with
    # identicle content
    render :index
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

    redirect_to request.referrer
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

    redirect_to request.referrer
  end

  def mark_sick_day
    sick_day = current_employee.sick_days.build(date: params[:date])

    if current_employee.can_mark_as_sick_day?(Date.parse(params[:date]))
      if sick_day.save
        flash[:success] = 'Successfully marked as sick day.'
      else
        flash[:danger] = sick_day.errors.full_messages.first
      end
    else
      flash[:danger] = 'You cannot mark that day as a sick day.'
    end

    redirect_to request.referrer
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
        redirect_to request.referrer
      end
    end

    def set_check_in
      @check_in = CheckIn.find(params[:id])
    end

    def set_week_variables
      start_date = params[:start_of_week] || Date.today.at_beginning_of_week
      @start_of_week = Date.parse(start_date.to_s)
      @week = @start_of_week..(@start_of_week + 4)

      @check_in_out_times = [] # array used to populate time table

      @week.each_with_index do |day, i|
        @check_in_out_times[i] = []

        current_employee.all_check_ins_on_date(day).each do |check_in|
          @check_in_out_times[i].push(check_in)
        end
      end
    end

    def validate_is_start_of_week
      date = Date.parse(params[:start_of_week])

      unless date == date.at_beginning_of_week
        redirect_to week_path(start_of_week)
      end
    end
end
