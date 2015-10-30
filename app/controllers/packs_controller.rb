class PacksController < ApplicationController
	def new
		@pack = Pack.new
	end

	def create
		@pack = Pack.new(pack_params)
		@pack.save
	end

	def edit
		@pack = Pack.find(params[:id])
	end

	def update
		@pack = Pack.find(params[:id])
		@pack.update_attributes(pack_params)
	end

	def index
		@packs = Pack.all
		respond_to do |format|
			format.csv { render text: @packs.to_csv }
		end
	end

	private

	def pack_params
		params.require(:pack).permit(:delivery_id, :menu_id, :quantity)
	end
end
