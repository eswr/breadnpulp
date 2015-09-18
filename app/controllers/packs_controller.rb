class PacksController < ApplicationController
	def new
		@pack = Pack.new
	end

	def create
		@pack = Pack.new(pack_params)
		@pack.save
	end

	def edit
	end

	def index
	end

	private

	def pack_params
		params.require(:pack).permit(:delivery_id, :menu_id, :quantity)
	end
end
