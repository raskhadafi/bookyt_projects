class BatchActivitiesController < ApplicationController
  def new
    # Allow callers specifying defaults
    @date = params[:date] || Date.today

    # TODO: only employees currently working for tenant
    people = current_tenant.company.employees

    @activities = people.map{|person|
      person.activities.build
    }
  end

  def create
    date = params[:batch_activities][:date]
    @activites = params[:activities].collect{|activity_params|
      Activity.create(activity_params.merge(:date => date, :minutes => "0"))
    }
  end
end
