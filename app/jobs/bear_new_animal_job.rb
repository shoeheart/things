# frozen_string_literal: true

class BearNewAnimalJob
  include Delayed::RecurringJob
  run_every 3.minutes
  queue 'batch'

  def initialize
    @current_user_emails = [
      "sysadmin@delayed.com",
      "joe@delayed.com",
      "jack@delayed.com",
      "jill@delayed.com",
      "jughead@delayed.com",
    ]
  end

  def perform
    Random.rand(0..2).times { |i|
      a = nil
      puts @current_user_emails
      puts @current_user_emails.sample
      Logidze.with_responsible(@current_user_emails.sample) {
        a =
          Animal.create(
            name: Faker::Name.first_name,
            species: Species.all.sample,
            is_vaccinated: [ true, false ].sample,
            birth_date: Random.rand(100..2000).days.ago
          )
        Random.rand(0..3).times { |i|
          a.toys << Toy.new(
            toy_type: ToyType.all.sample,
            acquired_on: Random.rand(10..100).days.ago
          )
        }
        puts "Bore new animal #{a.name} with #{a.toys.count} toys"
      }
    }
  end
end
