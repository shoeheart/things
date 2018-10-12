# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

shelter_emails = [
  "joe@shelter.com",
  "jack@shelter.com",
  "jill@shelter.com",
]

# create lookup values for toy types and species
Logidze.with_meta(responsible_id: "sysadmin@codebarn.com") {
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

# Create some people
10.times { |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.unique.email("#{first_name} #{last_name}")
  Logidze.with_meta(responsible_id: email) {
    p = Person.create(
      first_name: first_name,
      last_name: last_name,
      email: Faker::Internet.unique.email("#{first_name} #{last_name}"),
      birth_date: Faker::Date.between(8.years.ago, 50.years.ago),
    )
  }
}

# Schedule jobs to add/remove animals and adoptions and toys
# to simulate actual usage
::ShelterNewAnimalJob.schedule!
::NewToyForAdoptedAnimalJob.schedule!
::AdoptAnimalJob.schedule!
::AnimalDiesJob.schedule!
