class ActivitiesController < AuthorizedController
  belongs_to :project, :optional => true

  def new
    # Allow callers specifying defaults
    if params[:activity]
      @activity = Activity.new(params[:activity])
    else
      @activity = Activity.new(:date => Date.today)
    end

    # Educated guessing of person
    @activity.person = current_user.person if current_user

    # Educated guessing of project
    @activity.project_id ||= params[:project_id] if params[:project_id]
    @activity.project_id ||= @activity.person.activities.order(:duration_to).last

    new!
  end

  def create
    create! { @activity.project }
  end
end
