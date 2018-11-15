# frozen_string_literal: true

class AnimalsController < ApplicationController
  include Secured

  before_action :set_animal, only: [:update, :destroy]

  # GET /animals
  def index
    @animals = animals_with_display_attributes
  end

  # POST for creating new instance
  def create
    @animal = Animal.new(animal_params)
    Logidze.with_meta(responsible_id: current_user_email) do
      if @animal.save!
        render json: {
          animal: @animal,
          redirect_to: animals_path
        }
      else
        render json: {
          animal: @animal,
          note: @animal.errors
        }
      end
    end
  end

  # GET to show form to create new instance
  def new
    @animal = Animal.new
    @species = Species.all.order(:name)
    @toy_types = ToyType.all.order(:name)
  end

  # GET to display form to edit existing instance
  def edit
    @animal = Animal.find(params[:id])
    @toys =
      @animal.toys
        .joins(:toy_type)
        .select("
          toys.*,
          toy_types.id as toy_type_id,
          toy_types.name as toy_type_name
        ")
        .order("toys.acquired_on desc, toy_type_name asc")
    @species = Species.all.order(:name)
  end

  # POST /animal/1/add_toy
  def add_toy
    @toy =
      Toy.new(
        animal_id: params[:id],
        toy_type_id: params[:toy_type_id],
        acquired_on: params[:acquired_on]
      )

    Logidze.with_meta(responsible_id: current_user_email) do
      respond_to do |format|
        format.html {
          redirect_to animal_path(params[:id]),
          notice: (
            @toy.save ?
              "Toy was successfully added." :
              @toy.errors
          )
        }
      end
    end
  end

  # DELETE /animals/:id/delete_toy/:toy_id
  def delete_toy
    @toy = Toy.find(params[:toy_id])
    Logidze.with_meta(responsible_id: current_user_email) do
      @toy.delete
    end

    respond_to do |format|
      format.html {
        redirect_to animal_path(params[:id]),
        notice: "Toy was successfully deleted."
      }
    end
  end

  # PATCH/PUT /animals/1
  def update
    Logidze.with_meta(responsible_id: current_user_email) do
      if @animal.update(animal_params)
        render json: {
          animal: @animal,
          redirect_to: animals_path
        }
      else
        render json: {
          animal: @animal,
          note: @animal.errors
        }
      end
    end
  end

  # DELETE /animals/1
  def destroy
    Logidze.with_meta(responsible_id: current_user_email) {
      @animal.destroy
      respond_to do |format|
        format.html {
          redirect_to animals_url,
          notice: "Animal #{@animal.name} was successfully destroyed."
        }
      end
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal
      @animal = Animal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_params
      params.require(:animal).permit(
        :name,
        :species_id,
        :birth_date,
        :is_vaccinated,
        images: []
      )
    end

    def animals_with_display_attributes
      Animal
        .joins(:species)
        .left_outer_joins(:toys)
        .left_outer_joins(:person)
        .select("
          animals.id,
          animals.name,
          animals.species_id,
          animals.birth_date,
          animals.is_vaccinated,
          species.name as species_name,
          people.email as adopted_by_email,
          count(toys.id) as toy_count
        ")
        .group("
          animals.id,
          animals.name,
          animals.species_id,
          animals.birth_date,
          animals.is_vaccinated,
          species.name,
          people.email
        ")
        .order("animals.name, species.name")
        .limit(250)
    end
end
