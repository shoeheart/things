# frozen_string_literal: true

class ShelterNewAnimalJob
  include Delayed::RecurringJob
  run_every 1.seconds
  queue "batch"

  def initialize
    @shelter_emails = [
      "joe@shelter.com",
      "jack@shelter.com",
      "jill@shelter.com",
    ]
  end

  def perform
    Delayed::Worker.logger.debug "ShelterNewAnimalJob: Start"

    # only shelter as many as could be handled by number of people
    # assuming 2 animals per person, but not taking into account
    # how many animals the people already have
    if Animal.sheltered.count < (Person.count * 2)
      2.times.each { |i|
        Logidze.with_meta(responsible_id: @shelter_emails.sample) {
          name = Faker::Name.first_name
          Animal.create(
            name: name,
            species: Species.all.sample,
            is_vaccinated: [ true, false ].sample,
            birth_date: Random.rand(100..2000).days.ago
          )
          Delayed::Worker.logger.debug(
            "ShelterNewAnimalJob: Sheltered new animal #{name}"
          )
        }
      }
    end

    Delayed::Worker.logger.debug "ShelterNewAnimalJob: Done"
  end
end
