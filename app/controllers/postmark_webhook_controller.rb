# frozen_string_literal: true

class PostmarkWebhookController < ApplicationController
  skip_forgery_protection

  # POST for creating new instance
  def create
    webhook = PostmarkWebhook.new(payload: JSON.parse(request.raw_post))
    if webhook.save!
      render json: { status: 200 }
    else
      render json: { status: 500 }
    end
  end
end
