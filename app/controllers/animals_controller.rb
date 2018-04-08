# frozen_string_literal: true

class AnimalsController < ApplicationController
  include Secured

  before_action :set_animal, only: [:edit, :update, :destroy]

  # GET /animals
  # GET /animals.json
  def index
    @animals = animals_with_display_attributes
    @animal = Animal.new
    @species = Species.all.order(:name)
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

  # GET /animals/1
  # GET /animals/1.json
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

  # GET /animals/new
  def new
    @animal = Animal.new
    @species = Species.all.order(:name)
  end

  # POST /animals
  # POST /animals.json
  def create
    @animal = Animal.new(animal_params)

    respond_to do |format|
      if @animal.save!
        # re-read animal to add in the species and toy synthetic attributes
        @animal = animal_with_display_attributes(@animal.id)
        format.html {
          redirect_to animals_path,
          notice: "Animal #{@animal.name} was successfully created."
        }
        format.json { render :show, status: :created, location: @animal }
      else
        format.html { render :new }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
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

  # DELETE /animals/:id/delete_toy/:toy_id
  def delete_toy
    @toy = Toy.find(params[:toy_id])
    @toy.delete

    respond_to do |format|
      format.html {
        redirect_to animal_path(params[:id]),
        notice: "Toy was successfully deleted."
      }
    end
  end

  # PATCH/PUT /animals/1
  # PATCH/PUT /animals/1.json
  def update
    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to @animal, notice: "Animal was successfully updated." }
        format.json { render :show, status: :ok, location: @animal }
      else
        format.html { render :edit }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animals/1
  # DELETE /animals/1.json
  def destroy
    @animal.destroy
    respond_to do |format|
      format.html { redirect_to animals_url, notice: "Animal #{@animal.name} was successfully destroyed." }
      format.js
      format.json { head :no_content }
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
        :image
      )
    end
end
