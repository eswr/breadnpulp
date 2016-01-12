class TestRun
	require 'csv'

	def self.testiti
		CSV.foreach('TEMP/Powai Run Registration-batch2.csv', headers: false) do |row|
			user = User.new
			user.name = row[0]
			user.email = row[1]
			user.phone_number = row[2]
			user.password = User.new_token
			user.source = "Powai Run 2015"
			if user.save
				puts user.id
			else
				puts "nooo"
			end
		end
	end
end