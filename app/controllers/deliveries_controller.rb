class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:edit, :update, :index, :destroy]
	# before_action :correct_user,		only: [:edit, :update, :destroy ]
	# before_action :editable_delivery,	only: [:edit, :update]

	def new
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new
		@delivery_statuses = DeliveryStatus.all
		menus_on(active_menu_date).count.times { @delivery.packs.build }
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
	end

	def create
		@user = current_user
		@delivery = @user.deliveries.new(delivery_params)
		@delivery.booking_no = @delivery.get_b_no
		@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
		if @delivery.save
			flash[:success] = "Order successfully placed"
			redirect_to @user
			send_sms_to_admin flash[:success] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "praveen@breadnpulp.com"
			send_sms_to_admin flash[:success] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "shubham@breadnpulp.com"
		else
			flash[:danger] = "Order not placed. Please try again"
			redirect_to request.referrer || root_url
			send_sms_to_admin flash[:danger] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "praveen@breadnpulp.com"
			send_sms_to_admin flash[:danger] + ", " + @delivery.user.name + ", " + @delivery.user.phone_number + ", " + @delivery.at.to_s, "shubham@breadnpulp.com"
		end
	end

	def show
		@delivery = Delivery.find(params[:id])
	end

	def edit
		@delivery = Delivery.find(params[:id])
		@available_menus = Menu.where(available_on: @delivery.delivery_date)
		@delivery_statuses = DeliveryStatus.all
		@delivery.packs.build
	end

	def update
		@delivery = Delivery.find(params[:id])
		if @delivery.update_attributes(delivery_params)
			if @delivery.delivery_status.name.in? ["Confirmed", "Despatched"]
				send_sms @delivery
				send_sms_to_admin "Order confirmed for #{@delivery.user.name}, #{@delivery.user.phone_number}, #{@delivery.at.to_s}", "arvind@breadnpulp.com"
			end
			if !current_user.admin?
				@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
				@delivery.packs.each do |pack|
					pack.unit_price = pack.menu.get_price
				end
			end
			if @delivery.update_attributes delivery_params
				flash[:success] = "Order updated"
				redirect_to @delivery.user
			else
				flash[:danger] = "Order not updated. Please try again"
				redirect_to request.referrer || root_url
			end
		end
	end

	def index
		@deliveries = Delivery.order(delivery_date: :desc, at: :asc)
	end

	def destroy
		Delivery.find(params[:id]).destroy
	end

	def todays_orders
		@deliveries = Delivery.where("delivery_date = ?", Date.today).order(at: :asc)
	end

	def future_orders
		@deliveries = Delivery.where("delivery_date < ?", Date.today).order(delivery_date: :asc, at: :asc)
	end

	def recent_orders
		@deliveries = Delivery.where("delivery_date > ?", Date.today).order(delivery_date: :desc, at: :desc)
	end

	private

	def delivery_params
		params.require(:delivery).permit(:delivery_date, :at, :collect, :address_id, :delivery_status_id, :payment_date, :payment_mode, packs_attributes: [:id, :quantity, :menu_id, :unit_price, :payment_date, :payment_mode])
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
		Time.now.hour < 11 ? Time.now.to_date : Time.now.to_date.tomorrow
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
			"&text=Hi #{delivery.user.name.split(' ').first}! Your order for #{delivery.delivery_date}: #{delivery.delivery_status.name}." +
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
