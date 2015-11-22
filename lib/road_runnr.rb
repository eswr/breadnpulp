class RoadRunnr
	include HTTParty

	if Rails.env.production?
		base_uri "roadrunnr.in"
	else
		base_uri "apitest.roadrunnr.in"
	end

	def initialize
		@options = {
			headers: {
				"Content-Type" 				=> "Application/JSON",
				"Authorization" 			=> ENV['ROADRUNNR_TOKEN_PREFIX'] + " " + ENV['ROADRUNNR_TOKEN']
			}
		}
	end

	def get_driver_for(delivery)
		@query = {
			query: {
				"order_id" 					=> delivery.booking_no,
				"order_value" 				=> delivery.get_total_amount,
				"amount_to_be_collected" 	=> delivery.get_total_amount,
				"created_at"				=> delivery.created_at,
				"user"						=> {
					"name"					=> delivery.user.name,
					"phone_no"				=> delivery.user.phone_number
				},
				"user_address"				=> {
					"address"				=> delivery.address.full_address,
					"locality"				=> {
						"name"				=> "Koramangala"
					},
					"city"					=> {
						"name"				=> "Bangalore"
					}
				},
				"order_type"				=> {
					"name"					=> delivery.payment_mode
				}
			}
		}
		self.class.post("/orders/ship", @options.merge(@query))
	end

	private
end