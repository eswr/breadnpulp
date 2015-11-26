class DespatchesController < ApplicationController
	before_action :logged_in_user
	before_action :admin_user

	def new
		params[:date] ||= {
			year: 	Time.zone.now.year,
			month: 	Time.zone.now.month,
			day: 	Time.zone.now.day
		}
		@date = Time.new(params[:date][:year], params[:date][:month], params[:date][:day]).to_date
		@despatch = Despatch.new
		@deliveries = Delivery.where(delivery_date: @date, despatch_id: nil).where.not("delivery_status_id = ? OR delivery_status_id =?", DeliveryStatus.find_by(name: "Deactivated").id, DeliveryStatus.find_by(name: "Cancelled").id).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs).order(at: :asc)
	end

	def create
		@despatch = Despatch.new(despatch_params)
		if @despatch.save
			flash[:success] = "Yay!"
			Delivery.set_despatch @despatch.id, params["despatch"]["delivery_ids"]
			redirect_to new_despatch_path
		else
			flash.now[:danger] = "Nooo!"
			render 'new'
		end
	end

	def edit
		@despatch = Despatch.find(params[:id])
		@deliveries = Delivery.where(delivery_date: @despatch.despatch_date, despatch_id: nil).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	private
		def despatch_params
			params.require(:despatch).permit(:despatch_date, :despatch_time, :service_provider, { delivery_ids: [] })
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
