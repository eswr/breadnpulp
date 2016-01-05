class OtpsController < ApplicationController

	before_action :check_if_number

	def new
		@phone_number = params[:otp][:phone_number]
		user = User.find_by(phone_number: @phone_number)
		user.send_otp
		if !@phone_number.match(/\A[1-9]{1}\d{9}\z/)
			flash[:warning] = "Not a valid number"
			redirect_to :back
		elsif !user
			flash[:warning] = "Number not found!"
			redirect_to :back
		end
	end

	def create
		user = User.find_by(phone_number: params[:otp][:phone_number])
		if !user
			flash[:danger] = "Phone number not found! Please try again."
			redirect_to login_path
		else
			if user.authenticate_otp(params[:otp][:otp], drift: 60)
				user.activate if !user.activated?
				log_in user
				redirect_to user
			else
				flash[:danger] = "OTP incorrect. Please try again."
		      	redirect_to get_otp_path otp: { phone_number: params[:otp][:phone_number] }
		    end
		end
	end

	private

		def check_if_number
			redirect_to login_path if params[:otp][:phone_number].nil?
		end
end
