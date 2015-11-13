class RawMaterialsController < ApplicationController
	before_action		:logged_in_user
	before_action 		:admin_user

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
  	@raw_material = RawMaterial.find(params[:id])
  end

  def update
  	@raw_material = RawMaterial.find(params[:id])
  	if @raw_material.update_attributes(raw_material_params)
  		flash[:success] = "#{@raw_material.name} updated!"
  		redirect_to raw_materials_path
  	else
  		flash.now[:danger] = "#{@raw_material.name} not updated. Please try again."
  		render 'edit'
  	end
  end

  def index
  	@raw_materials = RawMaterial.all
  end

  private

  	def raw_material_params
  		params.require(:raw_material).permit(:name, :veg_non_egg)
  	end

  	def admin_user
		redirect_to root_path unless current_user.admin?
	end

	# Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end
end
