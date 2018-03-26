class ProfileController < ApplicationController

  def show
    @user = session[ :userinfo ]
  end

end
