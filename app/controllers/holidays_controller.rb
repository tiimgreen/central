class HolidaysController < ApplicationController
  before_action :authenticate_employee!

  def index
    @holiday = Holiday.new
  end
end
