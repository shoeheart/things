# frozen_string_literal: true

class AdoptAnimalJob
  include Delayed::RecurringJob
  run_every 20.seconds
  queue "batch"

  def initialize
  end

  def perform
    Delayed::Worker.logger.debug "AdoptAnimalJob: Start"
    adoptable_animal = Animal
      .sheltered
      .order(Arel.sql("random()"))
      .limit(1)
      .first

    adopter = Person
      .eligible_to_adopt
      .order(Arel.sql("random()"))
      .limit(1)
      .first

    Delayed::Worker.logger.debug(
      "AdoptAnimalJob: Adoptable Animal: #{adoptable_animal}"
    )
    Delayed::Worker.logger.debug(
      "AdoptAnimalJob: Adopter: #{adopter}"
    )

    if adoptable_animal && adopter
      Delayed::Worker.logger.debug(
        "AdoptAnimalJob: #{adopter.email} adopting #{adoptable_animal.name}"
      )
      Logidze.with_meta(responsible_id: adopter.email) {
        AnimalAdoption.create(
          person: adopter,
          animal: adoptable_animal,
          adopted_on: Time.now
        )
      }
    end

    Delayed::Worker.logger.debug "AdoptAnimalJob: Done"
  end
end
