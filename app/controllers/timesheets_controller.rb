class TimesheetsController < ApplicationController
  def index
    @employee = Employee.find(params[:employee_id])
    @employment = @employee.employments.current

    days = (Date.today.beginning_of_month..Date.today.end_of_month).to_a
    @work_days = days.map{|day| WorkDay.new(day, @employment)}
  end
end
