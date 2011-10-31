# Settings
# ========
source :rubygems

gemspec

# Rails
# =====
gem 'rails', '~> 3.1.0'

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
  #gem "capybara"

  # Fixtures
  gem "factory_girl_rails"

  # Matchers/Helpers
  gem 'shoulda'

  # Autotest
  # gem 'autotest'
  # gem 'autotest-rails'
  # gem 'ZenTest', '< 4.6.0' # Keep it working with gems < 1.8
end

group :test, :development do
  gem "rspec-rails"
  gem 'sqlite3'
  gem 'inherited_resources', '1.2.2'
  gem 'devise'
  gem 'cancan'
  gem 'validates_timeliness'
end
