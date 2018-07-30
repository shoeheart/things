# frozen_string_literal: true

class Person < SoftDeleteRecord
  has_logidze
  has_many :animal_adoptions
  has_many :animals, through: :animal_adoptions

  MAX_ANIMALS_PER_PERSON = 2

  scope :has_not_adopted, -> {
    where("people.id not in ( #{AnimalAdoption.select(:person_id).to_sql} )")
  }

  scope :eligible_to_adopt, -> {
    where("
      people.id in (
        #{
          Person
            .select("people.id")
            .distinct
            .left_outer_joins(:animals)
            .group("people.id")
            .having("count(animals.id) < " + MAX_ANIMALS_PER_PERSON.to_s)
            .to_sql
        }
      )
    ")
  }

  scope :has_adopted, -> {
    where("people.id in ( #{AnimalAdoption.select(:person_id).to_sql} )")
  }
end
