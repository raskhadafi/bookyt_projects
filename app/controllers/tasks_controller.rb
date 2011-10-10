class TasksController < AuthorizedController
  belongs_to :project

  def new
    # Allow callers specifying defaults
    @task = Task.new(params[:task])

    # Nested resources support
    @task.project_id ||= params[:project_id] if params[:project_id]

    # Educated guessing of defaults
    @task.person = current_user.person if current_user
    
    new!
  end

  def create
    @task = Task.create(params[:task])
    @project = @task.project

    create! { project_path(@project) }
  end

  def index
    redirect_to :projects
  end
end
