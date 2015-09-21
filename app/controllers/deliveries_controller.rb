class DeliveriesController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user,			only: [:index]
	before_action :correct_user,		only: [:create, :edit, :update, :destroy ]
	before_action :editable_delivery,	only: [:edit, :update]

	def new
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new
		@available_menus = Menu.where(available_on: active_menu_date).map { |menu| [menu.kickerr.name, menu.id] }
		@available_menus.count.times { @delivery.packs.build }
	end

	def create
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new(delivery_params)
		@delivery.delivery_status = DeliveryStatus.find_by(name: 'Confirmed')
		@delivery.save
		redirect_to @delivery
	end

	def show
		@delivery = Delivery.find(params[:id])
	end

	def edit
		@delivery = Delivery.find(params[:id])
		@available_menus = Menu.where(available_on: Date.today).map { |menu| [menu.kickerr.name, menu.id] }
	end

	def update
		@delivery = Delivery.find(params[:id])
		@delivery.update_attributes(delivery_params)
		redirect_to @delivery
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
		redirect_to new_delivery_path if Delivery.find(params[:id]).delivery_status.name = 'Confirmed'
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
		user = Delivery.find(params[:id]).user
		redirect_to root_path unless current_user(@user)
	end

end
