# frozen_string_literal: true

class Animal < ApplicationRecord
  has_one :pet_ownership
  has_one :person, through: :pet_ownership
  belongs_to :species
  has_many :toys

  has_many_attached :images

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


  scope :not_adopted, -> {
    # note this could cause double join when used to get to Person
    # even though you don't have associated person if this scope is true
    # left_outer_joins( :pet_ownership )
    # .where( "animal_id is null" )
    where("
      animals.id not in ( select animal_id from pet_ownerships )
    ")
  }

  scope :adopted, -> {
    # note this causes double join when used to get to Person
    # joins( :pet_ownership )
    # .where( "pet_ownerships.animal_id is not null" )
    where("
      animals.id in ( select animal_id from pet_ownerships )
    ")
  }

  scope :has_toys, -> {
    # joins( :toys )
    where("
      animals.id in ( select animal_id from toys )
    ")
  }

  scope :has_no_toys, -> {
    where("
      animals.id not in ( select animal_id from toys )
    ")
  }
end
