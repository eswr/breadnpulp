class Api::V1::SessionsController < Api::V1::BaseController

	def new
		phone_number = params[:phone_number]
		puts params
		if phone_number.nil? || phone_number.match(/\A[1-9]{1}\d{9}\z/)
			user = User.find_by(phone_number: phone_number)
			if user
				user.send_otp
				render json: { status: true, info: "sent otp to user" }
			else
				render json: { status: false, info: "user not found" }
			end
		else
			render json: { status: false, info: "invalid number" }
		end
	end

	def create
		phone_number = params[:phone_number]
		puts params
		user = User.find_by(phone_number: phone_number)
		if user && user.has_role?(:rider)# && user.authenticate_otp(params[:otp], drift: 60)
			user.remember
			render json: {
				status: true,
				info: "logged in",
				data: {
					user: {
						name: user.name,
						phone_number: user.phone_number,
						secret: user.remember_token
					}
				}
			}
		else
			render json: { status: false, info: "You do not access" }
		end
	end
end