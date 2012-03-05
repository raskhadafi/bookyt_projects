module BookytProjects
  module Navigation
    def setup_bookyt_projects(navigation)
      navigation.item :projects, t('bookyt.main_navigation.projects'), projects_path, :if => Proc.new { user_signed_in? } do |projects|
        projects.item :project_index, t_title(:index, Project), projects_path, :highlights_on => /\/(projects|activities)($|\/[0-9]*($|\/.*))/
        projects.item :new_project, t_title(:new, Project), new_project_path
        projects.item :divider, "", :class => 'divider'
        projects.item :capture_hours, t('activities.new.title'), new_batch_activity_path
      end
    end
  end
end
