class TimesheetsController < ApplicationController
  def index
    @employee = Employee.find(params[:employee_id])
    WorkDay.create_or_update_upto(@employee, Date.today.end_of_month)
    range = Date.today.beginning_of_month..Date.today.end_of_month
    @work_days = @employee.work_days.where(:date => range)
  end

  def start
    @employee = Employee.find(params[:employee_id])
    @employee.work_days.create(:date => params[:timesheet][:duration_from])

    redirect_to @employee
  end
end
