# frozen_string_literal: true

class ToysController < ApplicationController
  include Secured

  before_action :set_toy, only: [:edit, :update, :destroy]

  def toys_with_display_attributes
    Toy
      .joins(:toy_types)
      .left_outer_joins(:animals)
      .select("
        toys.*,
        toy_types.name as toy_type_name,
        animals.id as animal_id,
        animals.name as animal_name,
      ")
      .order("animals.name, toys.acquired_on desc")
  end

  # POST /toys
  # POST /toys.json
  def create
    @toy = Toy.new(toy_params)

    respond_to do |format|
      if @toy.save!
        # re-read toy to add in the species and toy synthetic attributes
        @toy = toy_with_display_attributes(@toy.id)
        format.html { redirect_to toys_path, notice: "Toy #{@toy.name} was successfully created." }
        # allow controller to respond to Ajax request
        format.js
        format.json { render :show, status: :created, location: @toy }
      else
        format.html { render :new }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /toys/1
  # PATCH/PUT /toys/1.json
  def update
    respond_to do |format|
      if @toy.update(toy_params)
        format.html { redirect_to @toy, notice: "Toy was successfully updated." }
        format.json { render :show, status: :ok, location: @toy }
      else
        format.html { render :edit }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /toys/1
  # DELETE /toys/1.json
  def destroy
    @toy.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_toy
      @toy = Toy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def toy_params
      params.require(:toy).permit(
        :animal_id,
        :acquired_on,
        :toy_type_id
      )
    end
end
