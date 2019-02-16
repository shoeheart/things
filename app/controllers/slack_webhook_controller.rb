# frozen_string_literal: true

class SlackWebhookController < ApplicationController
  skip_forgery_protection

  # POST for creating new instance
  def create
    unless valid_request?
      render json: {
        status: 500,
        "response_type": "ephemeral",
        "text": "Secure Signature check failed"
      }
    else
      safe_params = slack_webhook_params

      webhook = SlackWebhook.new(safe_params)
      if webhook.save!
        webhook.respond # executes in background via DelayedJob
        render json: {
          status: 200,
          text: "Request received"
        }
      else
        render json: {
          status: 500,
          "response_type": "ephemeral",
          "text": "Sorry, that didn't work. Please try again."
        }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    # example slack webhook post
    # token=gIkuvaNzQIHg97ATvDxqgjtO
    # &team_id=T0001
    # &team_domain=example
    # &enterprise_id=E0001
    # &enterprise_name=Globular%20Construct%20Inc
    # &channel_id=C2147483705
    # &channel_name=test
    # &user_id=U2147483697
    # &user_name=Steve
    # &command=/weather
    # &text=94070
    # &response_url=https://hooks.slack.com/commands/1234/5678
    # &trigger_id=13345224609.738474920.8088930838d88f008e0
    def slack_webhook_params
      params.permit(
        :token,
        :team_id,
        :team_domain,
        :enterprise_id,
        :enterprise_name,
        :channel_id,
        :channel_name,
        :user_id,
        :user_name,
        :command,
        :text,
        :response_url,
        :trigger_id,
        :ssl_check # special param for periodic ssl check ping from slack
      )
    end

    def valid_request?
      digest = OpenSSL::Digest::SHA256.new
      signature_basestring = [
        "v0",
        request.headers["X-Slack-Request-Timestamp"],
        request.raw_post
      ].join(":")
      hex_hash =
        OpenSSL::HMAC.hexdigest(
          digest,
          Rails.application.credentials.dig(:slack, :signing_secret),
          signature_basestring
        )
      computed_signature = ["v0", hex_hash].join("=")
      computed_signature == request.headers["X-Slack-Signature"]
    end
end
