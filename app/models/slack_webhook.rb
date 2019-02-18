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
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text":
              "*Latest Things Dashboard*\n" +
              ">animals_adopted: #{Animal.adopted.count}\n" +
              ">animals_sheltered: #{Animal.sheltered.count}\n" +
              ">animals_died: #{Animal.unscoped.deleted.count}\n" +
              ">people: #{Person.count}\n" +
              ">people_who_have_adopted: #{Person.has_adopted.count}\n" +
              ">people_eligible_to_adopt: #{Person.eligible_to_adopt.count}\n" +
              ">people_who_have_not_adopted: #{Person.has_not_adopted.count}\n" +
              ">toys_owned: #{Toy.count}\n" +
              ">toys_lost: #{Toy.unscoped.deleted.count}\n" +
              "Enjoy your day!"
          }
        }
      ]
    end
end
