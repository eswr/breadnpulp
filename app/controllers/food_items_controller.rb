class FoodItemsController < ApplicationController

	before_action		:logged_in_user
	before_action 		:admin_user
	def new
		@food_item = FoodItem.new
	end

	def show
		@food_item = FoodItem.find(params[:id])
	end

	def edit
		@food_item = FoodItem.find(params[:id])
	end

	def index
		@food_items = FoodItem.paginate(page: params[:page])
	end

	def create
		@food_item = FoodItem.new(food_item_params)
		if @food_item.save
			flash[:success] = "#{@food_item.name} created!"
			redirect_to food_items_path
		else
			flash.now[:danger] = "#{@food_item.name} not created, please try again"
			render 'new'
		end
	end

	def update
		@food_item = FoodItem.find(params[:id])
		if @food_item.update_attributes(food_item_params)
			flash[:success] = "#{@food_item.name} updated"
			redirect_to food_items_path
		else
			flash.now[:danger] = "#{@food_item.name} not updated, please try again"
		end
	end

	def destroy
		@food_item = FoodItem.find(params[:id])
		flash[:success] = "#{@food_item.name} deleted!"
		@food_item.destroy
		redirect_to food_items_path
	end

	private

		def food_item_params
			params.require(:food_item).permit(:name, :course, :veg_non_egg, :description, :image)
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
