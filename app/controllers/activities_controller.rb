class ActivitiesController < AuthorizedController
  belongs_to :project

  def new
    # Allow callers specifying defaults
    @activity = Activity.new(params[:activity])

    # Nested resources support
    @activity.project_id ||= params[:project_id] if params[:project_id]

    # Educated guessing of defaults
    @activity.person = current_user.person if current_user
    
    new!
  end

  def create
    @activity = Activity.create(params[:activity])
    @project = @activity.project

    create! { project_path(@project) }
  end

  def index
    redirect_to :projects
  end
end
