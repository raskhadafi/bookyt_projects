class TasksController < AuthorizedController
  
  def new
    @task = Task.new(:project_id => params[:project_id]) if params[:project_id]
    @task.person = current_user.person if current_user
    
    new!{ projects_url(@task.project) }
  end
   
end