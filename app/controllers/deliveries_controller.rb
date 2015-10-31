class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:edit, :update, :index, :destroy, :todays_orders, :recent_orders, :future_orders, :chef_view]
	# before_action :correct_user,		only: [:edit, :update, :destroy ]
	# before_action :editable_delivery,	only: [:edit, :update]

	def new
		@delivery = Delivery.new(delivery_params)
		@user = @delivery.user
		@delivery_statuses = DeliveryStatus.all
		@payment_statuses = PaymentStatus.all
		@address = @user.addresses.build(name: "New Address")
		@addresses = @user.addresses.map { |addr| [addr.postal_address.split('').first(40).join + '...', addr.id] }
		menus_on(active_menu_date).each do |menu|
			@delivery.packs.build(menu_id: menu.id)
		end
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
		# send_sms_to_admin "User on new order, " + @delivery.user.name, "praveen@breadnpulp.com"
		# send_sms_to_admin "User on new order, " + @delivery.user.name, "shubham@breadnpulp.com"
	end

	def create
		@delivery = Delivery.new(delivery_params)
		@delivery.delivery_date = active_menu_date
		@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
		@delivery.payment_status = PaymentStatus.find_by(name: 'Payment Due')
		if @delivery.address_id.nil?
			address = @delivery.user.addresses.new(delivery_params[:addresses_attributes])
			@delivery.address_id = address.id
		end
		if @delivery.save
			flash[:success] = "Order successfully placed"
			redirect_to @delivery.user
			send_sms_to_admin flash[:success] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "praveen@breadnpulp.com"
			send_sms_to_admin flash[:success] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "shubham@breadnpulp.com"
		else
			flash[:danger] = "Order not placed. Please make sure you've added an address first."
			redirect_to @delivery.user
			send_sms_to_admin flash[:danger] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "praveen@breadnpulp.com"
			send_sms_to_admin flash[:danger] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "shubham@breadnpulp.com"
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
		@deliveries = Delivery.paginate(:page => params[:page]).order(delivery_date: :desc, at: :asc)
		respond_to do |format|
			format.html
			format.csv { render text: Delivery.all.to_csv }
		end
	end

	def destroy
		Delivery.find(params[:id]).destroy
	end

	def todays_orders
		@deliveries = Delivery.where("delivery_date = ?", Time.zone.today).where.not("delivery_status_id = ? OR delivery_status_id = ?", DeliveryStatus.find_by(name: 'Deactivated'), DeliveryStatus.find_by(name: 'Cancelled')).order(at: :asc)
	end

	def future_orders
		@deliveries = Delivery.where("delivery_date > ?", Time.zone.today).order(delivery_date: :asc, at: :asc)
	end

	def recent_orders
		@deliveries = Delivery.paginate(:page => params[:page]).where("delivery_date < ?", Time.zone.today).order(delivery_date: :desc, at: :desc)
	end

	def chef_view
		@rows = Delivery.get_chef_view_rows
	end

	private

	def delivery_params
		params.require(:delivery).permit(:user_id, :delivery_date, :at, :collect, :address_id, :delivery_status_id, :payment_status_id, :payment_date, :payment_mode, packs_attributes: [:id, :quantity, :menu_id, :unit_price, :payment_date, :payment_mode, :_destroy], addresses_attributes: [:id, :name, :full_address, :pincode])
	end

	# def editable_delivery
	# 	return true if current_user.admin?
	# 	status = Delivery.find(params[:id]).delivery_status.name
	# 	if status != 'Tentative' && status != 'Confirmed'
	# 		flash[:danger] = "That order cannot be edited.. please make a new one"
	# 		redirect_to new_delivery_path
	# 	end
	# end

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

	# def correct_user
	# 	return true if current_user.admin?
	# 	user = current_user
	# 	redirect_to root_path unless current_user?(user)
	# end

	def send_sms (delivery)
		url = URI.parse(URI.encode("http://trx.orangesms.net/api/sendmsg.php?user=breadnpulp&pass=qweqwe&sender=BRDPLP" +
			"&phone=#{delivery.user.phone_number}" +
			"&text=Hi #{delivery.user.name.split(' ').first}! " +
			"Your order for #{delivery.delivery_date.strftime("%a %e %b %Y")}: #{delivery.delivery_status.name}." +
			" Thank you for choosing to eat with us. Congratulations on another step towards a healthy diet." +
			"&priority=ndnd&stype=normal"))
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
    end

    def send_sms_to_admin (message, admin_email)
		url = URI.parse(URI.encode("http://trx.orangesms.net/api/sendmsg.php?user=breadnpulp&pass=qweqwe&sender=BRDPLP" +
			"&phone=#{User.find_by(email: admin_email).phone_number}" +
			"&text=#{message}" +
			"&priority=ndnd&stype=normal"))
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
    end
end
