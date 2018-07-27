# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

current_user_emails = [
  "sysadmin@codebarn.com",
  "joe@codebarn.com",
  "jack@codebarn.com",
  "jill@codebarn.com",
  "jughead@codebarn.com",
]

Logidze.with_responsible(current_user_emails[0]) {
  10.times {
    Species.create(name: Faker::Ancient.unique.primordial)
  }
  toy_types = %w( Chewy Squeeky Plush Bone )
  toy_types.each { | toy_type |
    ToyType.create(name: toy_type)
  }
}

species = Species.all.to_a
toy_types = ToyType.all.to_a

5.times {
  a = nil
  Logidze.with_responsible(current_user_emails.sample) {
    a =
      Animal.create(
        name: Faker::Name.first_name,
        species: species.sample,
        is_vaccinated: [ true, false ].sample,
        birth_date: Random.rand(100..2000).days.ago
      )
    Random.rand(0..3).times { |i|
      a.toys << Toy.new(
        toy_type: toy_types.sample,
        acquired_on: Random.rand(10..100).days.ago
      )
    }
  }
  Random.rand(1..2).times { |i|
    Logidze.with_responsible(current_user_emails.sample) {
      a.update_attributes(
        name: Faker::Name.first_name,
        species: species.sample,
        is_vaccinated: [ true, false ].sample,
        birth_date: Random.rand(100..2000).days.ago
      )
    }
  }
  Random.rand(1..2).times { |i|
    Logidze.with_responsible(current_user_emails.sample) {
      a.update_attributes(
        species: species.sample,
        is_vaccinated: [ true, false ].sample,
      )
    }
  }
  Random.rand(1..2).times { |i|
    Logidze.with_responsible(current_user_emails.sample) {
      a.update_attributes(
        name: Faker::Name.first_name,
        birth_date: Random.rand(100..2000).days.ago
      )
    }
  }
  Random.rand(1..2).times { |i|
    Logidze.with_responsible(current_user_emails.sample) {
      a.update_attributes(
        name: Faker::Name.first_name,
        species: species.sample,
        is_vaccinated: [ true, false ].sample,
        birth_date: Random.rand(100..2000).days.ago
      )
    }
  }
}
3.times { |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  Logidze.with_responsible(current_user_emails.sample) {
    p = Person.create(
      first_name: first_name,
      last_name: last_name,
      email: Faker::Internet.unique.email("#{first_name} #{last_name}"),
      birth_date: Faker::Date.between(8.years.ago, 50.years.ago),
    )

    if ([ true, false ].sample)
      puts "Trying to adopt..."
      ([ (1..2).to_a.sample, Animal.not_adopted.count ].min).times { | i |
        puts "Adopting #{(i + 1).ordinalize} animal..."
        animal = Animal.not_adopted.first
        PetOwnership.create(
          person: p,
          animal: animal,
          adopted_on: Faker::Date.between(animal.birth_date, Date.today)
        )
      }
    end
  }
}
