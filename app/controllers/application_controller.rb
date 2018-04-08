# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # change partials path to frontend
  prepend_view_path Rails.root.join("frontend")
end
