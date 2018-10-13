# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  # included do
  #   before_action :logged_in?
  # end
  #
  # def logged_in?
  #   redirect_to "/" unless session[:userinfo].present?
  # end

  def current_user_email
    "not.logged.in@codebarn.com"
  end
end
