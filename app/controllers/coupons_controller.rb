class CouponsController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user

	def new
		@coupon = Coupon.new
		@coupons = Coupon.all.order(active: :desc)
	end

	def create
		@coupon = Coupon.new(coupon_params)
		if @coupon.save
			flash[:success] = "Yay!"
			redirect_to :back
		else
			flash.now[:danger] = "Nooo! Try again"
			render 'new'
		end
	end

	def edit
		@coupon = Coupon.find(params[:id])
	end

	def update
		@coupon = Coupon.find(params[:id])
		if @coupon.update_attributes(coupon_params)
			flash[:success] = "Yay!"
			redirect_to new_coupon_path
		else
			flash.now[:danger] = "Nooo! Please try again"
			render 'edit'
		end
	end

	def destroy
		@coupon = Coupon.find(params[:id])
		flash[:success] = "#{@coupon.code} deleted!"
		@coupon.destroy
		redirect_to new_coupon_path
	end

	private
		def coupon_params
			params.require(:coupon).permit(
				:code, :original_price,
				:final_price, :active)
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
