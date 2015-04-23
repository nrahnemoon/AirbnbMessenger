require "open-uri"

class Account < ActiveRecord::Base

	MAX_NUM_CLAIMED = 20

	has_many :messages, :through => :listings
	has_many :listings
	
	def new_access_code
		# Login AirBnB account
		response = HTTParty.post("https://api.airbnb.com/v1/authorize?currency=USD&locale=en-US&client_id=3092nxybyb0otqw18e8nh5nty",
    		:query => {
    			:grant_type => "password",
    			:password => self.password,
    			:username => self.email
    		},
    		:headers => {
    			"X-Airbnb-Device-ID" => "dac3843323d68940",
    			"User-Agent" => "Airbnb/160379 Android/4.4.2 Device/motorola_XT1031 Carrier/Republic Type/Mobile"
    		}
    	)
    	puts response
    	if response.success?
    		access_token = response.parsed_response["access_token"]
    		self.update_attributes(:access_token => access_token)
    		return access_token
    	end
	end
	
	def self.claim_listings
		unclaimed_listings = Listing.where(:account_id => nil)
		unclaimed_listings.each { |listing|
			listing.claim_listing
		}
	end
	
	def self.create_airbnb_account
		account = nil
		listing = nil
		first_name = nil
		last_name = nil
		num = nil
		loop do
			listing = Listing.order("RANDOM()").first
			first_name = listing.first_name.split(' ').last.gsub(/[^a-z]/i, '')
			last_name = Forgery('name').last_name
			num = 100_000 + Random.rand(1_000_000 - 100_000)
			break if !Account.exists?(:email => "#{first_name}.#{last_name}#{num}@gmail.com")
		end

		# Create AirBnB account
		response = HTTParty.post("https://api.airbnb.com/v1/users/create?currency=USD&locale=en-US&client_id=3092nxybyb0otqw18e8nh5nty",
    		:query => {
    			:last_name => last_name,
    			:first_name => first_name,
    			:password => "#{first_name}.#{last_name}#{num}",
    			:email => "#{first_name}.#{last_name}#{num}@gmail.com"
    		}
    	)
    	if response.success?
    		access_token = response.parsed_response["access_token"]

	    	# Download photo
	    	Mechanize.new.get(listing.picture_url).save "/tmp/#{first_name}.#{last_name}#{num}.jpg"

	    	# Update photo
			HTTMultiParty.post("https://api.airbnb.com/v1/account/update?currency=USD&locale=en-US&client_id=3092nxybyb0otqw18e8nh5nty",
				:query => {
					"user[photo]" => File.open("/tmp/#{first_name}.#{last_name}#{num}.jpg")
				},
				:headers => {
					"X-Airbnb-Device-ID" => "dac3843323d68940",
					"X-Airbnb-OAuth-Token" => access_token
				}
			)

			account = Account.create(
    			:email => "#{first_name}.#{last_name}#{num}@gmail.com",
    			:access_token => access_token,
    			:first_name => first_name,
    			:last_name => last_name,
    			:password => "#{first_name}.#{last_name}#{num}",
    			:picture_url => listing.picture_url,
    			:thumbnail_url => listing.thumbnail_url,
    			:airbnb_id => response.parsed_response["active_user"]["user"]["id"].to_s,
    			:num_claimed => 0
    		)
		end
	end
end
