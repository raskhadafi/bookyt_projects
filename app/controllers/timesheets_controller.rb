class TimesheetsController < ApplicationController
  def index
    @employee = Employee.find(params[:employee_id])
  end
end
