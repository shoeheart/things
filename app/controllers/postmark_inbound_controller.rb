# frozen_string_literal: true

class PostmarkInboundController < ApplicationController
  skip_forgery_protection

  # POST for creating new instance
  def create
    inbound = PostmarkInbound.new(payload: JSON.parse(request.raw_post))
    if inbound.save!
      render json: { status: 200 }
    else
      render json: { status: 500 }
    end
  end
end
