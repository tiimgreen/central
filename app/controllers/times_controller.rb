class TimesController < ApplicationController
  before_action :authenticate_employee!

  def index
    today = Date.today
    @week = today.at_beginning_of_week..(today.at_beginning_of_week + 4)
  end
end
