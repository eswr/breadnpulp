class Msg91
	include HTTParty
	debug_output $stdout

	base_uri "https://control.msg91.com/api"

	def self.send_sms(number, text)
		@query = {
			"authkey" 	=> ENV['MSG91_AUTH_KEY'],
			"mobiles" 	=> number,
			"message" 	=> text,
			"sender"	=> ENV['MSG91_SENDER_ID'],
			"route"		=> 4,
			"country"	=> "91",
			"flash"		=> 0,
			"response"	=> "json"
		}
		response = self.post("/sendhttp.php", body: @query, debug_output: $stdout)
		puts response.body
	end

	private
end