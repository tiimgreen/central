class TimesController < ApplicationController
  before_action :authenticate_employee!

  def index
  end
end
