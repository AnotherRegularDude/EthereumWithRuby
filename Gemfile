source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt', '~> 3.1.7'
gem 'ethereum.rb'
gem 'faker'
gem 'graphql'
gem 'hashie'
gem 'oj'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.5'
gem 'redis-rails'
gem 'virtus'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'capybara', '~> 2.13'
  gem 'dotenv-rails'
  gem 'selenium-webdriver'

  # Rspec stuff
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'graphiql-rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'database_cleaner', group: :test

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
