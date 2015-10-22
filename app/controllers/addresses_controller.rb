class AddressesController < ApplicationController
	before_action	:logged_in_user,		only: [:create, :destroy, :edit]
	before_action	:correct_user,			only: :destroy

	def create
		@address = Address.new(address_params)
		if @address.save
			flash[:success] = "Address created!"
			redirect_to @address.user
		else
			flash[:danger] = "Address not created, please try again"
	    	redirect_to request.referrer || root_url
		end
	end

	def destroy
		@address = Address.find(params[:id])
	    @address.destroy
	    flash[:success] = "Address deleted"
	    redirect_to request.referrer || root_url
	end

	def edit
		@address = Address.find(params[:id])
	end

	def update
		@address = Address.find(params[:id])
		if @address.update_attributes(address_params)
			flash[:success] = "#{@address.name} updated!"
			redirect_to @address.user
		else
			flash[:danger] = "#{@address.name} no updated! Please try again."
	    	redirect_to request.referrer || root_url
		end
	end

	private

		def address_params
			params.require(:address).permit(:user_id, :name, :full_address, :pincode)
		end

		def correct_user
		    @address = current_user.addresses.find_by(id: params[:id])
		    redirect_to current_user if @address.nil?
    	end

    	# Confirms a logged-in user.
	    def logged_in_user
	      unless logged_in?
	        store_location
	        flash[:danger] = "Please log in."
	        redirect_to login_path
	      end
	    end

end
