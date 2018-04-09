# frozen_string_literal: true

class ToyType < ApplicationRecord
  has_logidze
  has_many :toys
end
