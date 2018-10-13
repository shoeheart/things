# frozen_string_literal: true

FactoryBot.define do
  sequence :person_first_name do |n|
    "first_#{n}"
  end

  sequence :person_last_name do |n|
    "last_#{n}"
  end

  factory :person do
    first_name { generate(:person_first_name) }
    last_name { generate(:person_last_name) }
    email { "#{first_name}-#{last_name}@example.com".downcase }
    birth_date { 25.years.ago }
  end
end
