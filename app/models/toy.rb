# frozen_string_literal: true

class Toy < ApplicationRecord
  belongs_to :animal
  belongs_to :toy_type
end
