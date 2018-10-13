# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

gem "delayed_job_active_record"
gem "delayed_job_recurring"
gem "daemons"
gem "logidze"

gem "rails"
gem "pg"
gem "puma"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", git: "https://github.com/rails/webpacker.git"
gem "react-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# use in prod too for now
gem "faker"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution
  # and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara"
  gem "selenium-webdriver"
  gem "rspec-rails"
  # gem "faker" # pulled out for prod too for now while still seeding prod
  gem "rubocop"
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "dotenv"
  gem "rails-erd"
end

group :development do
  # Access an interactive console on exception pages or by
  # calling "console" anywhere in the code.
  gem "web-console"
  gem "listen"
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
