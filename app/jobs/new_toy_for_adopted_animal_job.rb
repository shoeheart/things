# frozen_string_literal: true

class NewToyForAdoptedAnimalJob
  include Delayed::RecurringJob
  run_every 4.seconds
  queue "batch"

  def initialize
  end

  def perform
    Delayed::Worker.logger.debug "NewToyForAdoptedAnimalJob: Start"

    receiving_animal = Animal
      .eligible_to_receive_toy
      .order(Arel.sql("random()"))
      .limit(1)
      .first

    if receiving_animal
      Logidze.with_meta(responsible_id: receiving_animal.person.email) {
        Delayed::Worker.logger.debug(
          "NewToyForAdoptedAnimalJob: #{receiving_animal.name} getting new toy"
        )
        receiving_animal.toys << Toy.new(
          toy_type: ToyType.all.shuffle.first,
          acquired_on: Time.now
        )
      }
    end

    Delayed::Worker.logger.debug "NewToyForAdoptedAnimalJob: Done"
  end
end
