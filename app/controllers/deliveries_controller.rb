class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:edit, :update, :index,
											   :destroy, :recent_deliveries,
											   :future_deliveries, :todays_deliveries, :despatch_delivery,
											   :confirm_delivery, :cancel_delivery, :despatch_delivery,
											   :return_delivery, :deliver_delivery]
	before_action :operator_user, 		only: [:todays_deliveries, :chef_view, :despatch_delivery]
	before_action :get_riders,			only: [:todays_deliveries, :index, :recent_deliveries, :future_deliveries]

	def new
		@delivery = Delivery.new(delivery_params)
		menus_on(active_menu_date).each do |menu|
			@delivery.packs.build(menu_id: menu.id, kickerr_name: menu.kickerr.name)
		end
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
		@payment_modes = {
			"Online payment" => "",
			"Cash on delivery" => "checked"
		}
	end

	def create
		@delivery = Delivery.new(delivery_params)
		@delivery.packs.each do |pack|
			pack.kickerr_name = pack.menu.kickerr.name
		end
		@delivery.delivery_date = active_menu_date
		@delivery.payment_status = PaymentStatus.find_by(name: 'Payment Due')
		if correct_user
			if @delivery.save
				if @delivery.payment_mode == 'Online payment'
					Ftcash.create_payment_order @delivery
					redirect_to ftcash_payment_path(id: @delivery.id)
				else
					@delivery.update_attribute :payment_date, @delivery.delivery_date
					flash[:success] = "Order successfully placed"
					redirect_to @delivery.user
				end
			else
				flash.now[:danger] = "Order not placed. Please make sure you've added an address first."
				render 'new'
			end
		else
			flash[:danger] = "haha! nice try!!"
			redirect_to root_path
		end
		@date = active_menu_date
	end

	def show
		@delivery = Delivery.find(params[:id])
	end

	def edit
		@delivery = Delivery.find(params[:id])
		@user = @delivery.user
		@available_menus = Menu.where(available_on: @delivery.delivery_date)
		@delivery_statuses = DeliveryStatus.all
		@payment_statuses = PaymentStatus.all
		@addresses = @user.addresses.map { |addr| [addr.postal_address.split('').first(40).join + '...', addr.id] }
		@delivery.packs.build
	end

	def update
		@delivery = Delivery.find(params[:id])
		if @delivery.update_attributes(delivery_params)
			flash[:success] = "Order updated"
			redirect_to todays_orders_path
		else
			flash[:danger] = "Order not updated. Please try again"
			redirect_to todays_orders_path
		end
	end

	def index
		@deliveries = Delivery.paginate(:page => params[:page])
							  .order(delivery_date: :desc, at: :asc)
							  .eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
		respond_to do |format|
			format.html
			format.csv { render text: Delivery.all.to_csv }
		end
	end

	def destroy
		Delivery.find(params[:id]).destroy
	end

	def todays_deliveries
		@deliveries = Delivery.where("delivery_date = ?", Time.zone.today)
							  .order(delivery_status_id: :asc, at: :asc)
							  .eager_load(:delivery_status, :payment_status, :user,
							  			  :address, :packs, :menus, :kickerrs)
	end

	def future_deliveries
		@deliveries = Delivery.where("delivery_date > ?", Time.zone.today).order(delivery_date: :asc, at: :asc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	def recent_deliveries
		@deliveries = Delivery.paginate(:page => params[:page]).where("delivery_date < ?", Time.zone.today).order(delivery_date: :desc, at: :desc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	def chef_view
		if !params["date"].nil?
	      	@date = Time.new(params["date"]["year"], params["date"]["month"], params["date"]["day"]).to_date
	    else
	      	@date = Time.now.to_date
	    end
		@rows = Delivery.get_chef_view_rows(@date)
	end

	def confirm_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.confirm_and_send_sms
		redirect_to :back
	end

	def cancel_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.cancel_and_send_sms
		redirect_to :back
	end

	def despatch_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.despatch_and_send_sms
		redirect_to :back
	end

	def return_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.return_and_send_sms
		redirect_to :back
	end

	def deliver_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.delivery_and_send_sms
		redirect_to :back
	end

	def ftcash_payment
		@delivery = Delivery.find(params[:id])
	end

	def assign_rider
		@delivery = Delivery.find(params[:delivery][:id])
		@delivery.assign_rider_and_send_sms params[:delivery][:rider_id]
		respond_to do |format|
			format.html { redirect_to :back }
			format.js
		end
	end

	private

	def delivery_params
		params.require(:delivery).permit(:user_id, :delivery_date, :at, :collect, :address_id, :delivery_status_id, :payment_status_id, :payment_date, :payment_mode, :despatch_id, :coupon_code, :rider_id, packs_attributes: [:id, :quantity, :menu_id, :unit_price, :payment_date, :payment_mode, :_destroy])
	end

	def active_menu_date
		Time.zone = 'Chennai'
		current_time = Time.zone
		if (current_time.now.hour == 11 && current_time.now.min < 15) || (current_time.now.hour < 11)
			current_time.today
		else
			current_time.tomorrow
		end	
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

	def correct_user
		if current_user.id == @delivery.user_id || current_user.admin?
			return true
		else
			return false
		end
	end

    def operator_user
    	return true if current_user.admin?
    	redirect_to root_path unless current_user.has_role? :operator
    end

    def get_riders
    	@riders = User.with_role(:rider).map { |rider| [rider.name, rider.id] } << nil
    end
end
