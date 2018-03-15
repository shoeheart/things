# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
%w( Aardvark Bumblebee Cat Dog ).each { | species |
  Species.create( name: species )
}
Animal.create( name: 'Alan', species: Species.find_by( name: 'Aardvark' ) )
Animal.create( name: 'Buzz', species: Species.find_by( name: 'Bumblebee' ) )
Animal.create( name: 'Mittens', species: Species.find_by( name: 'Cat' ) )
Animal.create( name: 'Fido', species: Species.find_by( name: 'Dog' ) )
