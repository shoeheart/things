# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.application.credentials.dig(:auth0, :audience).blank?
    audience =
      URI::HTTPS.build(
        host: Rails.application.credentials.dig(:auth0, :domain),
        path: "/userinfo"
      ).to_s
  else
    audience = Rails.application.credentials.dig(:auth0, :audience)
  end

  provider(
    :auth0,
    Rails.application.credentials.dig(:auth0, :client_id),
    Rails.application.credentials.dig(:auth0, :client_secret),
    Rails.application.credentials.dig(:auth0, :domain),
    callback_path: "/auth/auth0/callback",
    authorize_params: {
      scope: "openid email profile groups permissions roles",
      audience: audience
    }
  )
end
