# frozen_string_literal: true

class Toy < SoftDeleteRecord
  has_logidze
  belongs_to :animal
  belongs_to :toy_type
  validates :acquired_on, presence: true
end
