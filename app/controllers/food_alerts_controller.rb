class FoodAlertsController < ApplicationController

	def edit
		@food_alert = FoodAlert.find(params[:id])
	end

	def update
		@food_alert = FoodAlert.find(params[:id])
		if @food_alert.update_attributes(food_alert_params)
			flash[:success] = "Food Alert updated!!"
			redirect_to @food_alert.user
		else
			flash[:danger] = "Food Alert not updated, please try again"
			render 'edit'
		end
	end

	private

		def food_alert_params
			params.require(:food_alert).permit(:user_id, food_item_ids: [])
		end
end
