class TasksController < AuthorizedController
  def new
    # Allow callers specifying defaults
    @task = Task.new(params[:task])

    # Nested resources support
    @task.project_id ||= params[:project_id] if params[:project_id]

    # Educated guessing of defaults
    @task.person = current_user.person if current_user
    
    new!{ projects_url(@task.project) }
  end
end
