# frozen_string_literal: true

class AnimalDiesJob
  include Delayed::RecurringJob
  run_every 100.seconds
  queue "batch"

  def initialize
  end

  def perform
    Delayed::Worker.logger.debug "AnimalDiesJob: Start"
    animal_to_die = Animal.adopted.order("birth_date asc").first

    if animal_to_die
      Logidze.with_meta(responsible_id: animal_to_die.person.email) {
        AnimalAdoption.find_by(animal: animal_to_die).destroy
        animal_to_die.toys.destroy_all
        animal_to_die.destroy
      }
      Delayed::Worker.logger.debug(
        "AnimalDiesJob: #{animal_to_die.name} has died"
      )
    end

    Delayed::Worker.logger.debug "AnimalDiesJob: Done"
  end
end
