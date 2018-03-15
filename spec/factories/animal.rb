FactoryBot.define do
  sequence :name do |n|
    "animal_#{n}"
  end

  factory :animal do
    name { generate( :name ) }
  end
end
