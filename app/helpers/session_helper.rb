module SessionHelper
  def get_state
    state = SecureRandom.hex(24)
    session['omniauth.state'] = state

    state
  end

  PERMISSIONS_NAMESPACE = "https://codebarn.com/claims/permissions"
  def get_permissions
    session[:userinfo][:extra][:raw_info][PERMISSIONS_NAMESPACE] if (
      session[:userinfo] &&
      session[:userinfo][:extra] &&
      session[:userinfo][:extra][:raw_info]
    )
  end

  def write_animals?
    get_permissions.include?( "read-write:animals" )
  end

  def read_animals?
    get_permissions.include?( "read:animals" ) || write_animals?
  end

  def write_lookups?
    get_permissions.include?( "read-write:lookups" )
  end

  def read_lookups?
    get_permissions.include?( "read:lookups" ) || write_lookups?
  end

  def say_hello
    "Hello, world"
  end
end
