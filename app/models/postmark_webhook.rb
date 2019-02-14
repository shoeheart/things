# frozen_string_literal: true

class PostmarkWebhook < ApplicationRecord
  scope :deliveries, -> {
    where("postmark_webhooks.payload->>'RecordType' = 'Delivery'", true: "true")
  }
  scope :bounces, -> {
    where("postmark_webhooks.payload->>'RecordType' = 'Bounce'", true: "true")
  }
  scope :spam_complaints, -> {
    where("postmark_webhooks.payload->>'RecordType' = 'SpamComplaints'", true: "true")
  }
  scope :opens, -> {
    where("postmark_webhooks.payload->>'RecordType' = 'Open'", true: "true")
  }
  scope :clicks, -> {
    where("postmark_webhooks.payload->>'RecordType' = 'Click'", true: "true")
  }
end
