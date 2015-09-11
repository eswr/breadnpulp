class AddressesController < ApplicationController
	before_action	:logged_in_user,		only: [:create, :destroy, :edit]
	before_action	:correct_user,			only: :destroy

	def create
		@address = current_user.addresses.build(address_params)
		if @address.save
			flash[:success] = "Address created!"
			redirect_to @address.user
		else
			flash[:danger] = "Address not created, please try again"
	    	redirect_to request.referrer || root_url
		end
	end

	def destroy
	    @address.destroy
	    flash[:success] = "Address deleted"
	    redirect_to request.referrer || root_url
	end

	private

		def address_params
			params.require(:address).permit(:name, :full_address, :pincode)
		end

		def correct_user
		    @address = current_user.addresses.find_by(id: params[:id])
		    redirect_to current_user if @address.nil?
    	end

end
