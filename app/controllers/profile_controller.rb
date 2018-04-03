# frozen_string_literal: true

class ProfileController < ApplicationController
  def show
    @user = session[:userinfo]
  end
end
