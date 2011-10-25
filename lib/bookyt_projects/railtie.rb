require 'bookyt_projects'
require 'rails'

module BookytProjects
  class Railtie < Rails::Engine
    engine_name "bookyt_projects"

    config.to_prepare do
      ::Employee.send :include, BookytProjects::Employee
    end
  end
end
