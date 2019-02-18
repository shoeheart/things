# frozen_string_literal: true

# require "faraday"
class SlackWebhook < ApplicationRecord
  def respond
    response_hash = generate_response
    Rails.logger.info(
      "Responding to #{self.response_url} command #{self.text} with " +
      "#{JSON.pretty_generate(response_hash)}"
    )
    Faraday.new(self.response_url).post { |request|
      request.headers["Content-Type"] = "application/json"
      request.body = response_hash.to_json
    }
  end
  handle_asynchronously :respond, queue: "immediate"

  private
    def generate_response
      command = self.text.split(" ")[0]
      case command
      when nil
        generate_unknown_command
      when "dashboard"
        generate_dashboard
      when "animals"
        generate_animals
      when "toys"
        generate_toys
      else
        generate_unknown_command
      end
    end

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

    def generate_animals
      {
        "response_type": "ephemeral",
        "text": "*Animals Dashboard*",
        "attachments": [
          {
            "text":
              "animals adopted: #{Animal.adopted.count}\n" +
              "animals sheltered: #{Animal.sheltered.count}\n" +
              "animals died: #{Animal.unscoped.deleted.count}\n" +
              "*Enjoy your day!* :smile:"
          }
        ]
      }
    end

    def generate_people
      {
        "response_type": "ephemeral",
        "text": "*People Dashboard*",
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

    def generate_toys
      {
        "response_type": "ephemeral",
        "text": "*Toys Dashboard*",
        "attachments": [
          {
            "text":
              "toys owned: #{Toy.count}\n" +
              "toys lost: #{Toy.unscoped.deleted.count}\n" +
              "*Enjoy your day!* :smile:"
          }
        ]
      }
    end

    def generate_unknown_command
      {
        "response_type": "ephemeral",
        "text": "*Unknown request.  Valid commands are:*",
        "attachments": [
          {
            "text":
              "[dashboard | animals | people | toys]\n" +
              "*Try again!* :smile:"
          }
        ]
      }
    end
end
