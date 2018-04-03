# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Things
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set this if you want to get the error_description
    OmniAuth.config.on_failure = Proc.new { |env|
      message_key = env["omniauth.error.type"]
      error_description = Rack::Utils.escape(env["omniauth.error"].error_reason)
      new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=
    => #{message_key}&error_description=#{error_description}"
      Rack::Response.new(["302 Moved"], 302, "Location": new_path).finish
    }
  end
end
