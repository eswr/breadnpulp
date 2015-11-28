class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:edit, :update, :index, :destroy, :recent_orders, :future_orders]
	before_action :operator_user, 		only: [:todays_orders, :chef_view]
	# before_action :editable_delivery,	only: [:edit, :update]

	def new
		@delivery = Delivery.new(delivery_params)
		@user = @delivery.user
		@delivery_statuses = DeliveryStatus.all
		@payment_statuses = PaymentStatus.all
		@addresses = @user.addresses.map { |addr| [addr.postal_address.split('').first(40).join + '...', addr.id] }
		menus_on(active_menu_date).each do |menu|
			@delivery.packs.build(menu_id: menu.id)
		end
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
	end

	def create
		@delivery = Delivery.new(delivery_params)
		return if !correct_user
		@delivery.delivery_date = active_menu_date
		if current_user.admin?
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Confirmed')
		else
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
		end
		@delivery.payment_status = PaymentStatus.find_by(name: 'Payment Due')
		if @delivery.address_id.nil?
			address = @delivery.user.addresses.new(delivery_params[:addresses_attributes])
			@delivery.address_id = address.id
		end
		if @delivery.save
			flash[:success] = "Order successfully placed"
			redirect_to @delivery.user
		else
			flash[:danger] = "Order not placed. Please make sure you've added an address first."
			redirect_to @delivery.user
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
		@deliveries = Delivery.paginate(:page => params[:page]).order(delivery_date: :desc, at: :asc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
		respond_to do |format|
			format.html
			format.csv { render text: Delivery.all.to_csv }
		end
	end

	def destroy
		Delivery.find(params[:id]).destroy
	end

	def todays_orders
		@deliveries = Delivery.where("delivery_date = ?", Time.zone.today).where("delivery_status_id = ? OR delivery_status_id = ?", DeliveryStatus.find_by(name: 'Tentative'), DeliveryStatus.find_by(name: 'Confirmed')).order(at: :asc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	def future_orders
		@deliveries = Delivery.where("delivery_date > ?", Time.zone.today).order(delivery_date: :asc, at: :asc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	def recent_orders
		@deliveries = Delivery.paginate(:page => params[:page]).where("delivery_date < ?", Time.zone.today).order(delivery_date: :desc, at: :desc).eager_load(:delivery_status, :payment_status, :user, :address, :packs, :menus, :kickerrs)
	end

	def chef_view
		@rows = Delivery.get_chef_view_rows
	end

	def reset_despatch
		Delivery.find(params[:id]).update_attribute :despatch_id, nil
		redirect_to :back
	end

	private

	def delivery_params
		params.require(:delivery).permit(:user_id, :delivery_date, :at, :collect, :address_id, :delivery_status_id, :payment_status_id, :payment_date, :payment_mode, :despatch_id, packs_attributes: [:id, :quantity, :menu_id, :unit_price, :payment_date, :payment_mode, :_destroy])
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
		return true if current_user.admin?
		user = @delivery.user
		redirect_to root_path unless current_user?(user)
		return false
	end

    def operator_user
    	return true if current_user.admin?
    	redirect_to root_path unless current_user.has_role? :operator
    end
end
