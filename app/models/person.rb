class Person < ApplicationRecord
  has_many :pet_ownerships
  has_many :animals, through: :pet_ownerships

  scope :has_not_adopted, -> {
    where( "
      people.id not in ( select person_id from pet_ownerships )
    ")
  }

  scope :has_adopted, -> {
    where( "
      people.id in ( select person_id from pet_ownerships )
    ")
  }
end
