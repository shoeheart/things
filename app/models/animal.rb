class Animal < ApplicationRecord
  has_one :pet_ownership
  has_one :person, through: :pet_ownership
  belongs_to :species
  has_many :toys

  has_one_attached :image

  scope :not_adopted, -> {
    # note this could cause double join when used to get to Person
    # even though you don't have associated person if this scope is true
    # left_outer_joins( :pet_ownership )
    # .where( "animal_id is null" )
    where( "
      animals.id not in ( select animal_id from pet_ownerships )
    ")
  }

  scope :adopted, -> {
    # note this causes double join when used to get to Person
    # joins( :pet_ownership )
    # .where( "pet_ownerships.animal_id is not null" )
    where( "
      animals.id in ( select animal_id from pet_ownerships )
    ")
  }

  scope :has_toys, -> {
    # joins( :toys )
    where( "
      animals.id in ( select animal_id from toys )
    ")
  }

  scope :has_no_toys, -> {
    where( "
      animals.id not in ( select animal_id from toys )
    ")
  }
end
