# frozen_string_literal: true

class RenameAdoptedAnimalJob
  include Delayed::RecurringJob
  run_every 47.seconds
  queue "batch"

  def initialize
  end

  def perform
    Delayed::Worker.logger.debug "RenameAdoptedAnimalJob: Start"

    animal_to_rename = Animal.adopted.shuffle.first

    if animal_to_rename
      Logidze.with_responsible(animal_to_rename.person.email) {
        old_name = animal_to_rename.name
        new_name = Faker::Name.first_name
        animal_to_rename.update_attributes({
          name: new_name
        })
        Delayed::Worker.logger.debug "RenameAdoptedAnimalJob: #{old_name} renamed #{new_name}"
      }
    end

    Delayed::Worker.logger.debug "RenameAdoptedAnimalJob: Done"
  end
end

