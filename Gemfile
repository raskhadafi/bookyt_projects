# Settings
# ========
source :rubygems

gemspec

# Rails
# =====
gem 'rails', '~> 3.1'

# Development
# ===========
group :development do
end

# Test
# ====
group :test do
  # Framework
  gem "rspec-rails"

  # Browser
  gem "capybara"

  # Fixtures
  gem "factory_girl_rails"

  # Autotest
  # gem 'autotest'
  # gem 'autotest-rails'
  # gem 'ZenTest', '< 4.6.0' # Keep it working with gems < 1.8
end

group :test, :development do
  gem "rspec-rails"
  gem 'mysql2'
end

# Matchers/Helpers
gem 'shoulda'

# Date/Time handling
# ==================
gem 'validates_timeliness'

# Access Control
# ==============
gem 'devise'
gem 'cancan'

gem 'inherited_resources', '1.2.2'
gem 'has_scope'
