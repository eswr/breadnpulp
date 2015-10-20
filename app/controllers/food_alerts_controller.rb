class FoodAlertsController < ApplicationController

	before_action :logged_in_user
	before_action :correct_user
	before_action :admin_user, only: :index

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

	def index
		@food_alerts = FoodAlert.get_food_alerts
		user_ids = @food_alerts.map{ |key, value| key }.uniq
		@users = User.get_from_ids(user_ids)
	end

	def show
	end

	private

		def food_alert_params
			params.require(:food_alert).permit(:user_id, food_item_ids: [])
		end

		# Confirms a logged-in user.
	    def logged_in_user
	      unless logged_in?
	        store_location
	        flash[:danger] = "Please log in."
	        redirect_to login_path
	      end
	    end

	    # Confirms the correct user.
	    def correct_user
	      return true if current_user.admin?
	      @user = User.find(params[:id])
	      redirect_to(root_url) unless current_user?(@user)
	    end
	    
	    # Confirms an admin user.
	    def admin_user
	      redirect_to(root_url) unless current_user.admin?
	    end
end
