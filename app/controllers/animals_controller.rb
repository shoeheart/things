class AnimalsController < ApplicationController
  #before_action :set_animal, only: [:show, :edit, :update, :destroy]
  before_action :set_animal, only: [:edit, :update, :destroy]

  # /ujs/animals_totals
  def totals
    @species_totals =
      Animal
        .joins( :species )
        .group( "species.name" )
        .order( "species.name" )
        .count

    # allow controller to respond to Ajax request
    # format.js
  end

  # GET /animals
  # GET /animals.json
  def index
    # see https://code.tutsplus.com/articles/improving-the-performance-of-your-rails-app-with-eager-loading--cms-25018
    @animals =
      Animal
        .joins( :species )
        .select( "animals.*, species.name as species_name" )
        .order( 'animals.name' )
    @animal = Animal.new
    @species = Species.all.order( :name )
  end

  # GET /animals/1
  # GET /animals/1.json
  def show
    # see https://code.tutsplus.com/articles/improving-the-performance-of-your-rails-app-with-eager-loading--cms-25018
    @animal =
      Animal
        .joins( :species )
        .select(
          "animals.*, species.id as species_id, species.name as species_name"
        )
        .find( params[:id] )
  end

  # GET /animals/new
  def new
    @animal = Animal.new
    @species = Species.all.order( :name )
  end

  # GET /animals/1/edit
  def edit
    @species = Species.all.order( :name )
    @animal =
      Animal
        .joins( :species )
        .select(
          "animals.*, species.id as species_id, species.name as species_name"
        )
        .find( params[:id] )
  end

  # POST /animals
  # POST /animals.json
  def create
    @animal = Animal.new(animal_params)

    respond_to do |format|
      if @animal.save
        # re-read animal to add in the species_name synthetic attribute
        @animal =
          Animal
            .joins( :species )
            .select(
              "animals.*, species.id as species_id, species.name as species_name"
            )
            .find( @animal.id )
        format.html { redirect_to @animal, notice: 'Animal was successfully created.' }
        # allow controller to respond to Ajax request
        format.js
        format.json { render :show, status: :created, location: @animal }
      else
        format.html { render :new }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1
  # PATCH/PUT /animals/1.json
  def update
    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to @animal, notice: 'Animal was successfully updated.' }
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
      format.html { redirect_to animals_url, notice: 'Animal was successfully destroyed.' }
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
      params.require(:animal).permit(:name, :species_id)
    end
end
