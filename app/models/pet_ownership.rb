class PetOwnership < ApplicationRecord
  belongs_to :animal
  belongs_to :person
end
