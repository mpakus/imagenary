source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

# Use mysql as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'spring', group: :development

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

#### Imagenary gems
gem 'mini_magick'
gem 'carrierwave' # upload files
gem 'nprogress-rails' # turbolinks progressbar
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :github => 'anjlab/bootstrap-rails', :branch => 'master'

group :production do
  gem 'unicorn'
  gem 'therubyracer', platforms: :ruby
  #gem 'newrelic_rpm'
end

group :development do
  gem 'net-ssh', '2.7.0'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'better_errors'
  gem 'meta_request'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'binding_of_caller'
  gem 'jazz_hands'
  gem 'awesome_print'
  #gem 'rb-fsevent'
  #gem 'guard-livereload'
  #gem 'sunspot_solr'
end

group :development, :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rspec-rails'#, '~> 2.0'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
end