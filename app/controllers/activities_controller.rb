class ActivitiesController < AuthorizedController
  belongs_to :project, :optional => true

  def new
    # Allow callers specifying defaults
    if params[:activity]
      @activity = Activity.new(params[:activity])
    else
      @activity = Activity.new(:when => Date.today)
    end

    # Nested resources support
    @activity.project_id ||= params[:project_id] if params[:project_id]
    # Educated guessing of defaults
    @activity.person = current_user.person if current_user

    new!
  end

  def create
    create! { @activity.project }
  end
end
