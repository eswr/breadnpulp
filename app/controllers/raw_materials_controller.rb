class RawMaterialsController < ApplicationController
  def new
  	@raw_material = RawMaterial.new
  end

  def create
  	@raw_material = RawMaterial.new(raw_material_params)
  	if @raw_material.save
  		flash[:success] = "#{@raw_material.name} created!"
  		redirect_to raw_materials_path
  	else
  		flash.now[:danger] = "#{@raw_material.name} not created. Please try again"
  		render 'new'
  	end
  end

  def edit
  end

  def index
  end

  private

  	def raw_material_params
  		params.require(:raw_material).permit(:name, :veg_non_egg)
  	end
end
