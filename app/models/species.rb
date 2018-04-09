# frozen_string_literal: true

class Species < ApplicationRecord
  has_logidze
  has_many :animals
end
