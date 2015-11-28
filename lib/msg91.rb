class Msg91
	include HTTParty

	base_uri "https://control.msg91.com/api"

	def self.send_sms(number, text)
		@query = {
			query: {
				"authkey" 	=> ENV['MSG91_AUTH_KEY'],
				"mobiles" 	=> number,
				"message" 	=> text,
				"sender"	=> ENV['MSG91_SENDER_ID'],
				"route"		=> "4"
			}
		}
		self.class.post("/sendhttp.php", @query)
	end
	handle_asynchronously :send_sms

	private
end