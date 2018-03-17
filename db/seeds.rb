# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
species = %w( Aardvark Bumblebee Cat Dog )
species.each { | species |
  Species.create( name: species )
}
toy_types = %w( Chewy Squeeky Plush Bone )
toy_types.each { | toy_type |
  ToyType.create( name: toy_type )
}
{
  'Alan': 'Aardvark',
  'Buzz': 'Bumblebee',
  'Patches': 'Cat',
  'Fido': 'Dog',
  'Arthur': 'Aardvark',
  'Billy': 'Bumblebee',
  'Mittens': 'Cat',
  'Rover': 'Dog',
}.each{ | name, species |
  a =
    Animal.create(
      name: name,
      species: Species.find_by( name: species ),
      is_vaccinated: [ true, false ].sample,
      birth_date: Random.rand( 100..3000 ).years.ago
    )
  Random.rand(1..5).times { |i|
    Toy.create(
      toy_type: ToyType.find(
        Random.rand( toy_types.length * 5 ).modulo( toy_types.length ) + 1
      ),
      acquired_on: Random.rand( 10..100 ).days.ago,
      animal: a
    )
  }
}
