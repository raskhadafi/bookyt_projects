class BatchActivitiesController < ApplicationController
  def new
    # Allow callers specifying defaults
    @date = params[:date] || Date.today

    # TODO: only employees currently working for tenant
    people = current_tenant.company.employees

    @activities = people.map{|person|
      person.activities.build(:project => person.latest_project)
    }
  end

  def create
    date = Date.parse(params[:batch_activities][:date])
    @activites = params[:activities].collect{|activity_params|
      Activity.create(activity_params.merge(:date => date))
    }

    redirect_to activities_path(:by_date => date.to_s(:db))
  end
end
