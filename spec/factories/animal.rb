FactoryBot.define do
  sequence :animal_name do |n|
    "animal_#{n}"
  end

  factory :animal do
    name { generate( :animal_name ) }
    association :species
  end
end
