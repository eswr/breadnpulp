class DespatchesController < ApplicationController
	before_action :logged_in_user
	before_action :admin_user
	before_action :get_date

	def new
		@despatch = Despatch.new
		@drops = Drop.where(drop_date: @date, despatch_id: nil)
					 .order(expected_at: :asc)
	end

	def create
		@despatch = Despatch.new(despatch_params)
		if @despatch.save
			flash[:success] = "Yay!"
			Drop.set_despatch @despatch.id, params["despatch"]["drop_ids"]
			redirect_to new_despatch_path
		else
			flash.now[:danger] = "Nooo!"
			render 'new'
		end
	end

	def index
		@despatches = Despatch.where(despatch_date: @date)
							  .eager_load(:user, :drops)
							  .order(despatch_time: :asc)
	end

	private
		def despatch_params
			params.require(:despatch).permit(:despatch_date, :despatch_time, :service_provider, :user_id, { drop_ids: [] })
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
