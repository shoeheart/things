# frozen_string_literal: true

class PetOwnership < ApplicationRecord
  has_logidze
  belongs_to :animal
  belongs_to :person
end
