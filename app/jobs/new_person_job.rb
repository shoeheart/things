# frozen_string_literal: true

class NewPersonJob
  include Delayed::RecurringJob
  run_every 3.seconds
  queue "batch"

  def initialize
  end

  def perform
    Delayed::Worker.logger.debug "NewPersonJob: Start"

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.unique.email("#{first_name} #{last_name}")
    Logidze.with_meta(responsible_id: email) {
      p = Person.create(
        first_name: first_name,
        last_name: last_name,
        email: email,
        birth_date: Faker::Date.between(8.years.ago, 50.years.ago),
      )
    }

    Delayed::Worker.logger.debug(
      "NewPersonJob: Created person #{p.first_name} #{p.last_name}"
    )

    Delayed::Worker.logger.debug "NewPersonJob: Done"
  end
end
