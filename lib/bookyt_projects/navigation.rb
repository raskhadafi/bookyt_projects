module BookytProjects
  module Navigation
    def setup_bookyt_projects(navigation)
      navigation.item :projects, t_model(Project), projects_path, :if => Proc.new { user_signed_in? } do |projects|
        projects.item :project_index, t_title(:index, Project), projects_path, :highlights_on => /\/projects($|\/[0-9]*($|\/.*))/
        projects.item :new_project, t_title(:new, Project), new_project_path
        projects.item :project_states, t_model(ProjectState), project_states_path, :highlights_on => /\/project_states($|\/([0-9]*|new)($|\/.*))/ 
        # projects.item :new_project_state, t_title(:new, ProjectState), new_project_state_path
      end
    end
  end
end