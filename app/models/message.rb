class Message < ActiveRecord::Base

	belongs_to :listing

	INTRO_MESSAGE = "hiya!"
	
	def self.send_messages
		ip = Ip.last #set_new_ip("ap-northeast-1")
		puts "Assigned IP #{ip.address}"
		ssh = Net::SSH.start(ip.address, "ubuntu")
		puts "Established SSH connection"

		10.times { |i|
			puts "Creating account nick5991#{i}@gmail.com"
			airbnb_device_id = rand(9999999999999).to_s.center(13, rand(12).to_s)
			ssh.exec!("curl -s -v --data 'last_name=Box&first_name=ShareFi&password=asdf12344&email=nick599192#{i}@gmail.com' --header 'X-Airbnb-Device-ID: dac#{airbnb_device_id}' --header 'User-Agent: Airbnb/160382 Android/4.4.2' --header 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' https://api.airbnb.com/v1/users/create?client_id=3092nxybyb0otqw18e8nh5nty > create_response")
			create_response = ssh.exec!("cat create_response")
			puts "\n\nResponse=\n#{create_response}\n\n"
			create_json = JSON.parse(create_response)
			access_token = create_json["access_token"]
			puts "Got back access token #{access_token}"
			20.times { |j|
				puts "Sending message #{j}"
				ssh.exec!("curl -s -v --data \"message=#{INTRO_MESSAGE}&checkin_date=2015-04-01T00%3A00%3A00.000-0700&checkout_date=2015-04-02T00%3A00%3A00.000-0700&number_of_guests=1&listing_id=5182447\" --header \"X-Airbnb-Device-ID: dac#{airbnb_device_id}\" --header \"X-Airbnb-OAuth-Token: #{access_token}\" https://api.airbnb.com/v1/threads/create?client_id=3092nxybyb0otqw18e8nh5nty > message_response")
				message_response = ssh.exec!("cat message_response")
				puts "\n\nResponse=\n#{message_response}\n\n"
				message_json = JSON.parse(message_response)
				if (message_json["result"] == "success")
					thread_id = message_json["thread"]["thread"]["id"]
					puts "Message #{j} successful!  Thread id #{thread_id}"
					Message.create(
						:text => INTRO_MESSAGE,
						:listing_id => -1,
						:airbnb_thread_id => thread_id)
				end
			}
		}
	end

	def self.send_airbnb_message(listing, text)
		access_code = listing.account.new_access_code
		if access_code == nil
			return false
		end
		checkin_date = listing.get_checkin_date
		checkout_date = checkin_date + 1.day

		# Create AirBnB account
		response = HTTParty.post("https://api.airbnb.com/v1/threads/create?currency=USD&locale=en-US&client_id=3092nxybyb0otqw18e8nh5nty",
    		:query => {
    			:message => text,
    			:checkout_date => checkout_date.to_s,
    			:checkin_date => checkin_date.to_s,
    			:number_of_guests => "1",
    			:listing_id => listing.airbnb_id
    		},
			:headers => {
				"X-Airbnb-Device-ID" => "dac3843323d68940",
				"X-Airbnb-OAuth-Token" => access_code
			}
    	)
    	puts response
    	if response.success?
    		puts response
    		return response.parsed_response["result"]
    	end
	end
end
