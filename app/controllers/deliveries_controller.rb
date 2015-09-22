class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:index]
	before_action :correct_user,		only: [:edit, :update, :destroy ]
	before_action :editable_delivery,	only: [:edit, :update]

	def new
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new
		@available_menus = Menu.where(available_on: active_menu_date).map { |menu| [menu.kickerr.name, menu.id] }
		@available_menus.count.times { @delivery.packs.build }
	end

	def create
		@user = current_user
		@delivery = @user.deliveries.new(delivery_params)
		if !current_user.admin?
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Tentative')
			flash[:success] = "Order successfully placed. We'll confirm it shorly."
		else
			@delivery.delivery_status = DeliveryStatus.find_by(name: 'Confirmed')
			flash[:success] = "Order confirmed!"
			send_sms @delivery
		end
		@delivery.save
		redirect_to @user
	end

	def show
		@delivery = Delivery.find(params[:id])
	end

	def edit
		@delivery = Delivery.find(params[:id])
		@available_menus = Menu.where(available_on: @delivery.on).map { |menu| [menu.kickerr.name, menu.id] }
	end

	def update
		@delivery = Delivery.find(params[:id])
		if !current_user.admin?
			params[:delivery_status] = DeliveryStatus.find_by(name: 'Tentative')
		end
		if @delivery.update_attributes(delivery_params)
			send_sms @delivery
			redirect_to @delivery.user
		end
	end

	def index
		@deliveries = Delivery.all
	end

	def destroy
		Delivery.find(params[:id]).destroy
	end

	private

	def delivery_params
		params.require(:delivery).permit(:on, :at, :collect, :address_id, packs_attributes: [:id, :quantity, :menu_id])
	end

	def editable_delivery
		return true if current_user.admin?
		status = Delivery.find(params[:id]).delivery_status.name
		if status != 'Tentative' && status != 'Confirmed'
			flash[:danger] = "That order cannot be edited.. please make a new one"
			redirect_to new_delivery_path
		end
	end

	def active_menu_date
		Time.now.hour < 12 ? Date.today : Date.tomorrow
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
		user = current_user
		redirect_to root_path unless current_user?(user)
	end

	def send_sms (delivery)
		url = URI.parse("http://trx.orangesms.net/api/sendmsg.php?user=breadnpulp&pass=qweqwe&sender=BRDPLP" +
			"&phone=#{delivery.user.phone_number}" +
			"&text=Hi #{delivery.user.name.split(' ').first}! Your order for #{delivery.on}: #{delivery.delivery_status.name}." +
			"&priority=ndnd&stype=normal").gsub(' ', '%20')
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
    end
end
