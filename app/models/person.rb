# frozen_string_literal: true

class Person < SoftDeleteRecord
  has_logidze
  has_many :animal_adoptions
  has_many :animals, through: :animal_adoptions

  scope :has_not_adopted, -> {
    where("
      people.id not in ( select person_id from animal_adoptions )
    ")
  }

  scope :has_adopted, -> {
    where("
      people.id in ( select person_id from animal_adoptions )
    ")
  }
end
