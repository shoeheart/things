# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @counts = calculate_counts
  end

  def counts
    render json: calculate_counts
  end

  private
    def calculate_counts
      {
        animals_adopted: Animal.adopted.count,
        animals_sheltered: Animal.sheltered.count,
        animals_died: Animal.unscoped.deleted.count,
        people: Person.count,
        people_who_have_adopted: Person.has_adopted.count,
        people_eligible_to_adopt: Person.eligible_to_adopt.count,
        people_who_have_not_adopted: Person.has_not_adopted.count,
        toys_owned: Toy.count,
        toys_lost: Toy.unscoped.deleted.count,
      }
    end
end
