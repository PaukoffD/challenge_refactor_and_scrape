source 'https://rubygems.org'

# ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'

# Controllers
gem 'inherited_resources'

# models
gem 'activemodel-associations'
gem 'selenium'
gem 'watir-webdriver'

# views
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'haml-rails'
gem 'simple_form'

# doc
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  if (Gem::Specification.map(&:name) & %w[rb-fchange rb-inotify rb-fsevent]).empty?
    if RUBY_PLATFORM =~ /win32/
      gem 'rb-fchange'
      gem 'rb-notifu'
    elsif RUBY_PLATFORM =~ /linux/
      gem 'rb-inotify'
      gem 'libnotify'
    elsif RUBY_PLATFORM =~ /darwin/
      gem 'rb-fsevent'
      gem 'growl'
    end
  end

  gem "rspec-rails"
  gem 'guard-rspec'

  # i18n + templates and tools
  gem 'active_record_model_and_rspec_enhanced_templates'
  gem 'advanced_haml_scaffold_generator'
  gem 'factory_girl_fixtures_template'
  # gem 'i18n_scaffold_controller_template'
  gem 'i18n_scaffold_generator'
  gem 'jbuilder_rspec_generator'
  gem 'rspec_rails_scaffold_templates'
  gem 'translations_sync'
end


group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'annotate', '~> 2.6.5'
  gem 'quiet_assets'

  # To load the directory
  gem 'require_all'
end

group :test do
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '2.8.0', require: false

  gem 'factory_girl_rails', github: 'dima4p/factory_girl_rails'
end
