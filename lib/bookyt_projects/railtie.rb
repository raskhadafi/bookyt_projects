require 'bookyt_projects'
require 'rails'

module BookytProjects
  class Railtie < Rails::Engine
    config.to_prepare do
      ::Employee.send :include, BookytProjects::Employee
    end
  end
end
