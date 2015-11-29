class DropsController < ApplicationController
	before_action :logged_in_user
	before_action :admin_user
	before_action :get_date

	def new
	@drop = Drop.new
	@deliveries = Delivery.where(delivery_date: @date, drop_id: nil)
						  .where.not("delivery_status_id = ? OR delivery_status_id =?",
						  	         DeliveryStatus.find_by(name: "Deactivated").id,
						  	         DeliveryStatus.find_by(name: "Cancelled").id)
						  .eager_load(:delivery_status, :payment_status, :user,
						  			  :address, :packs, :menus, :kickerrs)
						  .order(at: :asc)
	end

	def create
		@drop = Drop.new(drop_params)
		if @drop.save
			flash[:success] = "Yay!"
			Delivery.set_drop @drop.id, params["drop"]["delivery_ids"]
			redirect_to new_drop_path
		else
			flash.now[:danger] = "Nooo!"
			render 'new'
		end
	end

	def index
		@drops = Drop.where(drop_date: @date)
					 .eager_load(:deliveries)
					 .order(expected_at: :asc)
	end

	private

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

		def drop_params
			params.require(:drop).permit(:drop_address, :expected_at,
										 :completed_at, :drop_date)
		end

		def get_date
			Time.zone = "Chennai"
			params[:date] ||= {
				year: 	Time.zone.now.year,
				month: 	Time.zone.now.month,
				day: 	Time.zone.now.day
			}
			@date = Time.new(params[:date][:year],
							 params[:date][:month],
							 params[:date][:day]
							 ).to_date
		end
end
