# frozen_string_literal: true

FactoryBot.define do
  sequence :animal_name do |n|
    "animal_#{n}"
  end

  factory :animal do
    name { generate(:animal_name) }
    association :species
    is_vaccinated true
    birth_date 3.years.ago
  end
end
