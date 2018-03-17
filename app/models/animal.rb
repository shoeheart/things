class Animal < ApplicationRecord
  belongs_to :species
  has_many :toys
end
