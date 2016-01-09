class AddressesController < ApplicationController
	before_action	:logged_in_user,		only: [:create, :destroy, :edit]
	before_action	:correct_user,			only: :destroy
	# skip_before_filter :verify_authenticity_token, :only => :create

	def new
		@address = Address.new
	end

	def create
		@address = Address.new(address_params)
		if @address.save
	      	respond_to do |format|
	          	format.html { 
	          		flash[:success] = "Address created!"
					redirect_to :back 
				}
	          	format.js # { render :action => "create_success" }  #rails now looks for success.js.erb
	        end
	    else
	      	respond_to do |format|
	        	format.html { render :action => 'new'}
	        	format.js # { render :action => "create_failure" }  #rails now looks for failure.js.erb
	      	end
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

	def index
		@addresses = Address.order(created_at: :asc)
		respond_to do |format|
			format.html
			format.csv { render text: @addresses.to_csv}
		end
	end

	private

		def address_params
			params.require(:address).permit(:user_id, :name, :full_address, :locality, :city, :pincode)
		end

		def correct_user
			return true if current_user.admin?
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
