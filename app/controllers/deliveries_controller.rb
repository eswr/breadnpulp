class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:edit, :update, :index,
											   :destroy, :recent_deliveries,
											   :future_deliveries, :todays_deliveries, :despatch_delivery]
	before_action :operator_user, 		only: [:todays_deliveries, :chef_view, :despatch_delivery]
	before_action :get_riders,			only: [:todays_deliveries, :index, :recent_deliveries, :future_deliveries]

	def new
		@delivery = Delivery.new(delivery_params)
		menus_on(active_menu_date).each do |menu|
			@delivery.packs.build(menu_id: menu.id, kickerr_name: menu.kickerr.name)
		end
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
	end

	def create
		@delivery = Delivery.new(delivery_params)
		@delivery.delivery_date = active_menu_date
		if current_user.admin?
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Confirmed')
		else
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
		end
		@delivery.payment_status = PaymentStatus.find_by(name: 'Payment Due')
		if params[:commit] == 'Place order'
			if correct_user
				if @delivery.save
					flash[:success] = "Order successfully placed"
					redirect_to @delivery.user
				else
					flash.now[:danger] = "Order not placed. Please make sure you've added an address first."
					render 'new'
				end
			else
				flash[:danger] = "haha! nice try!!"
				redirect_to root_path
			end
		elsif params[:commit] == 'Check coupon'
			coupon = Coupon.find_by(code: params[:delivery][:coupon_code])
			puts coupon
			if coupon && coupon.active?
				flash.now[:info] = 'Coupon code validated. Please place the order'
				render 'new'
			else
				flash.now[:warning] = 'Coupon code not validated'
				render 'new'
			end
		end
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
		@rows = Delivery.get_chef_view_rows
	end

	def despatch_delivery
		@delivery = Delivery.find(params[:id])
		@delivery.despatch_and_send_sms
		redirect_to :back
	end

	private

	def delivery_params
		params.require(:delivery).permit(:user_id, :delivery_date, :at, :collect, :address_id, :delivery_status_id, :payment_status_id, :payment_date, :payment_mode, :despatch_id, :coupon_code, :rider_id, packs_attributes: [:id, :quantity, :menu_id, :unit_price, :payment_date, :payment_mode, :_destroy])
	end

	def active_menu_date
		Time.zone = 'Chennai'
		Time.zone.now.hour < 11 ? Time.zone.now.to_date : Time.zone.now.to_date.tomorrow
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
