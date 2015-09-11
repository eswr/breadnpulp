module ApplicationHelper

	require 'net/http'

	# Returns the full title on a per-page basis.       # Documentation comment
	def full_title(page_title = '')                     # Method def, optional arg
		base_title = "Ruby on Rails Tutorial Sample App"  # Variable assignment
		if page_title.empty?                              # Boolean test
	  		base_title                                      # Implicit return
		else
	  		page_title + " | " + base_title                 # String concatenation
		end
	end

	# Send sms to admin
	def send_sms_to(number, text)
		url = URI.parse('http://trx.orangesms.net/api/sendmsg.php?user=breadnpulp&pass=qweqwe&sender=BRDPLP' +
			'&phone=#{number}' +
			'&text=#{text}' +
			'&priority=ndnd&stype=normal')
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
  			http.request(req)
		}
		puts res.body
	end
end