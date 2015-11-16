class CompanyHolidaysController < ApplicationController

  def index
    redirect_to employee_holidays_path
  end

  def new
    @company_holiday = CompanyHoliday.new
  end

  def create
    @company_holiday = CompanyHoliday.new(company_holiday_params)

    if @company_holiday.save
      flash[:success] = 'Holiday created!'
      redirect_to company_holidays_path
    else
      flash[:danger] = @company_holiday.errors.full_messages.first
      render :new
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

  private

    def company_holiday_params
      params.require(:company_holiday).permit(:date)
    end
end
