# frozen_string_literal: true

class SoftDeleteRecord < ApplicationRecord
  self.abstract_class = true
  include SoftDelete
end
