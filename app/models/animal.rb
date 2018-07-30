# frozen_string_literal: true

class Animal < SoftDeleteRecord
  has_logidze
  has_one :animal_adoption
  has_one :person, through: :animal_adoption
  belongs_to :species
  has_many :toys, dependent: :destroy

  MAX_TOYS_PER_ANIMAL = 3

  # must use eigen class to pull class methods into symbol namespace
  class << self
    def hello_immediate
      puts "Hello immediate from #{Animal.count} animals"
    end
    handle_asynchronously :hello_immediate, queue: "immediate"

    def hello_interactive
      puts "Hello interactive from #{Animal.count} animals"
    end
    handle_asynchronously :hello_interactive, queue: "interactive"

    def hello_batch
      puts "Hello batch (default) from #{Animal.count} animals"
    end
    handle_asynchronously :hello_batch
  end

  scope :sheltered, -> {
    # note this could cause double join when used to get to Person
    # even though you don't have associated person if this scope is true
    # left_outer_joins( :animal_adoption )
    # .where( "animal_id is null" )
    where("animals.id not in ( #{AnimalAdoption.select(:animal_id).to_sql} )")
  }

  scope :adopted, -> {
    # note this causes double join when used to get to Person
    # joins( :animal_adoption )
    # .where( "animal_adoptions.animal_id is not null" )
    where("animals.id in ( #{AnimalAdoption.select(:animal_id).to_sql} )")
  }

  scope :has_toys, -> {
    where("animals.id in ( #{Toy.select(:animal_id).distinct.to_sql} )")
  }

  scope :has_no_toys, -> {
    where("animals.id not in ( #{Toy.select(:animal_id).distinct.to_sql} )")
  }

  scope :eligible_to_receive_toy, -> {
    where("
      animals.id in (
        #{
          Animal
            .select("animals.id")
            .distinct
            .joins(:person)
            .left_outer_joins(:toys)
            .group("animals.id")
            .having("count(toys.id) < " + MAX_TOYS_PER_ANIMAL.to_s)
            .to_sql
        }
      )
    ")
  }

  scope :ineligible_to_receive_toy, -> {
    where("
      animals.id not in (
        #{
          Animal
            .select("animals.id")
            .distinct
            .joins(:person)
            .left_outer_joins(:toys)
            .group("animals.id")
            .having("count(toys.id) < " + MAX_TOYS_PER_ANIMAL.to_s)
            .to_sql
        }
      )
    ")
  }
end
