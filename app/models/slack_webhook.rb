# frozen_string_literal: true

class SlackWebhook < ApplicationRecord
  def respond
    Rails.logger.info "Responding to #{self.response_url}"
  end
  handle_asynchronously :respond, queue: "immediate"
end
