# frozen_string_literal: true

class AnimalAdoption < SoftDeleteRecord
  has_logidze
  belongs_to :animal
  belongs_to :person
end
