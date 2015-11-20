class CompanyHolidaysController < ApplicationController
  before_action :authenticate_employee!

  def index
    @company_holidays = CompanyHoliday.all.order(:date)
    @company_holiday = CompanyHoliday.new
  end

  def create
    # Variables needed in-case the form fails, Rails will stay on the create action
    @company_holiday = CompanyHoliday.new
    @company_holidays = CompanyHoliday.all.order(:date)

    date_range, holidays, errors = params[:company_holiday][:date], [], false

    parse_date_range(date_range).each do |date|
      company_holiday = CompanyHoliday.new(date: date)

      if company_holiday.save
        holidays << company_holiday
      else
        holidays << company_holiday
        errors = true
      end
    end

    if errors
      flash[:danger] = holidays.last.errors.full_messages.first
      render :index
    else
      flash[:success] = 'Holiday created!'
      redirect_to company_holidays_path
    end
  end

  def show
    @company_holiday = CompanyHoliday.find(params[:id])
  end

  def edit
    @company_holiday = CompanyHoliday.new
  end

  def update
  end

  def destroy
    @company_holiday = CompanyHoliday.find(params[:id])

    if @company_holiday.destroy
      flash[:success] = 'Successfully deleted Company Holiday!'
    else
      flash[:danger] = 'Error deleting Company Holiday'
    end

    redirect_to request.referrer
  end

  private

    def company_holiday_params
      params.require(:company_holiday).permit(:date)
    end
end
