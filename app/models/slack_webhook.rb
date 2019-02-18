# frozen_string_literal: true

# require "faraday"
class SlackWebhook < ApplicationRecord
  def respond
    dashboard_hash = generate_dashboard
    Rails.logger.info(
      "Responding to #{self.response_url} with " +
      "#{JSON.pretty_generate(dashboard_hash)}"
    )
    Faraday.new(self.response_url).post { |request|
      request.headers["Content-Type"] = "application/json"
      request.body = dashboard_hash.to_json
    }
  end
  handle_asynchronously :respond, queue: "immediate"

  private
    def generate_dashboard
      {
        "response_type": "ephemeral",
        "text": "*Latest Things Dashboard*",
        "attachments": [
          {
            "text":
              "animals adopted: #{Animal.adopted.count}\n" +
              "animals sheltered: #{Animal.sheltered.count}\n" +
              "animals died: #{Animal.unscoped.deleted.count}\n" +
              "people: #{Person.count}\n" +
              "people who have adopted: #{Person.has_adopted.count}\n" +
              "people eligible to adopt: #{Person.eligible_to_adopt.count}\n" +
              "people who have not adopted: #{Person.has_not_adopted.count}\n" +
              "toys owned: #{Toy.count}\n" +
              "toys lost: #{Toy.unscoped.deleted.count}\n" +
              "*Enjoy your day!* :smile:"
          }
        ]
      }
    end
end
