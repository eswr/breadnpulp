class DeliveriesController < ApplicationController

	before_action :editable_delivery,		only: [:edit, :update, :destroy]

	def new
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new
		@delivery.packs.build
	end

	def create
		logged_in? ? @user = current_user : @user = User.new
		@delivery = @user.deliveries.new(delivery_params)
		@delivery.save
		redirect_to @delivery
	end

	def show
		@delivery = Delivery.find(params[:id])
	end

	def edit
		@delivery = Delivery.find(params[:id])
	end

	def update
		@delivery = Delivery.find(params[:id])
		@delivery.save
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
		params.require(:delivery).permit(:on, :at, :collect, :address_id, { packs_attributes: [:id, :quantity, :menu_id] })
	end

	def editable_delivery
		redirect_to new_delivery_path if Delivery.find(params[:id]).delivery_status.id > 2
end
end
