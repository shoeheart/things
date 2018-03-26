# frozen_string_literal: true
class LogoutController < ApplicationController
  include Secured
  include LogoutHelper
  def logout
    reset_session
    redirect_to logout_url.to_s
  end
end
