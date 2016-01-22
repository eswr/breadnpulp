class Api::V1::RidersController < Api::V1::BaseController
	def kitchen_details
		rider = Rider.find_by(phone_number: params[:phone_number])
		if rider && rider.authenticated?(:remember, params[:secret])
			kitchen = rider.kitchen
			render json: {
				status: true,
				data: {
					kitchen: {
						name: kitchen.name,
						address: kitchen.address
					}
				}
			}
		else
			render json: {
				status: true,
				info: 'not authenticated'
			}
		end
	end

	# def despatches
		
end