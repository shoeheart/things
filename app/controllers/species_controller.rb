class SpeciesController < ApplicationController
  include Secured

  before_action(
    :set_species,
    only: [:show, :edit, :update, :destroy]
  )

  # GET /species
  # GET /species.json
  def index
    @species = Species.all.order( :name )
    @species_new = Species.new
  end

  # GET /species/1
  # GET /species/1.json
  def show
  end

  # GET /species/new
  def new
    @species = Species.new
  end

  # GET /species/1/edit
  def edit
  end

  # POST /species
  # POST /species.json
  def create
    @species = Species.new(species_params)
    sleep 1

    respond_to do |format|
      if @species.save
        format.html { redirect_to species_index_path, notice: 'Species was successfully created.' }
        format.json { render :show, status: :created, location: @species}
      else
        format.html { render :new }
        format.json { render json: @species.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /species/1
  # PATCH/PUT /species/1.json
  def update
    respond_to do |format|
      if @species.update(speciesparams)
        format.html { redirect_to @species, notice: 'Species was successfully updated.' }
        format.json { render :show, status: :ok, location: @species}
      else
        format.html { render :edit }
        format.json { render json: @specieserrors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /species/1
  # DELETE /species/1.json
  def destroy
    @species.destroy
    respond_to do |format|
      format.html { redirect_to species_index_path, notice: 'Species was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_species
      @species = Species.find(params[:id])
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def species_params
      params.require(:species).permit( :name )
    end
end
