# frozen_string_literal: true

class AnimalsController < ApplicationController
  include Secured

  before_action :set_animal, only: [:update, :destroy]

  # TODO: Move to right helper spot
  def current_user_email
    email = nil
    if (
      session[:userinfo] &&
      session[:userinfo]["info"] &&
      session[:userinfo]["info"]["email"]
    )
      email = session[:userinfo]["info"]["email"]
    end
    email
  end

  # GET /animals
  def index
    @animals = animals_with_display_attributes
    @animal = Animal.new
    @species = Species.all.order(:name)
  end

  def react_index
    @animals = animals_with_display_attributes
    @animal = Animal.new
    @species = Species.all.order(:name)
  end

  # GET /animals/1
  def show
    @animal = animal_with_display_attributes(params[:id])
    @species = Species.all.order(:name)
    @toy_types = ToyType.all.order(:name)
    @toys =
      @animal.toys
        .joins(:toy_type)
        .select("
          toys.*,
          toy_types.id as toy_type_id,
          toy_types.name as toy_type_name
        ")
        .order("toys.acquired_on desc")
  end

  # POST /animals
  #
  # currently only used from index page so
  # redirects back there only as opposed
  # some new/edit form
  def create
    @animal = Animal.new(animal_params)

    Logidze.with_responsible(current_user_email) do
      respond_to do |format|
        if @animal.save!
          # re-read animal to add in the species and toy synthetic attributes
          @animal = animal_with_display_attributes(@animal.id)
          format.html {
            redirect_to animals_path,
            notice: "Animal #{@animal.name} was successfully created."
          }
        else
          format.html {
            redirect_to animals_path,
            notice: @animal.errors
          }
        end
      end
    end
  end

  # POST /animal/1/add_toy
  def add_toy
    @toy =
      Toy.new(
        animal_id: params[:id],
        toy_type_id: params[:toy_type_id],
        acquired_on: params[:acquired_on]
      )

    Logidze.with_responsible(current_user_email) do
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
    Logidze.with_responsible(current_user_email) do
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
    Logidze.with_responsible(current_user_email) do
      respond_to do |format|
        format.html {
          redirect_to @animal,
          notice: (
            @animal.update(animal_params) ?
              "Animal was successfully updated." :
              @animal.errors
          )
        }
      end
    end
  end

  # DELETE /animals/1
  def destroy
    @animal.destroy
    respond_to do |format|
      format.html {
        redirect_to animals_url,
        notice: "Animal #{@animal.name} was successfully destroyed."
      }
    end
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
        .select("
          animals.id,
          animals.name,
          animals.species_id,
          animals.birth_date,
          animals.is_vaccinated,
          species.name as species_name,
          count(toys.id) as toy_count
        ")
        .group("animals.id, animals.name, species.name")
        .order("animals.name")
    end

    def animal_with_display_attributes(id)
      Animal
        .joins(:species)
        .left_outer_joins(:toys)
        .select("
          animals.id,
          animals.name,
          animals.species_id,
          animals.birth_date,
          animals.is_vaccinated,
          species.name as species_name,
          count(toys.id) as toy_count
        ")
        .group("animals.id, animals.name, species.name")
        .find(id)
    end
end
