# frozen_string_literal: true

FactoryBot.define do
  sequence :species_name do |n|
    "species_#{n}"
  end

  factory :species do
    name { generate(:species_name) }
  end
end
