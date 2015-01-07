source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use postgres as the database for Active Record
gem 'pg'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'devise', '~> 3.4.1'
gem 'annotate', '~> 2.6.5'
gem 'haml'
gem 'simple_token_authentication', '~> 1.6.0'
gem 'cancan', '~> 1.6.10'
gem 'devise-async', '~>0.9.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'dotenv'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'spork-rails'
  gem 'thin'
  gem 'faker'
  gem 'railroady' # for generating UML diagrams
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

# Code analysis tools

gem 'reek'
gem 'rails_best_practices'
gem 'rubocop'

gem 'rails_12factor', group: :production

# Use delayed jobs
gem 'delayed_job_active_record'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
