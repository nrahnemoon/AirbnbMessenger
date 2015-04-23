class Listing < ActiveRecord::Base

	belongs_to :account
	has_many :messages

	def send_initial_message
		if !self.messages
			Message.send_message(self, "")
		end
	end

	def get_checkin_date
		# Get listing unavailabilities
		response = HTTParty.get("https://api.airbnb.com/v1/listings/#{self.airbnb_id}/unavailabilities?locale=en-US&client_id=3092nxybyb0otqw18e8nh5nty")
		checkin_date = DateTime.now.change({ hour: 0, min: 0, sec: 0 }) + 10.days
		checkout_date = checkin_date + 1.day
		unavailabilities = response.parsed_response["result"]["unavailabilities"]
		while unavailabilities.include?(checkin_date.strftime("%Y-%m-%d")) || unavailabilities.include?(checkout_date.strftime("%Y-%m-%d"))
			checkin_date += 1.day
			checkout_date += 1.day
		end
		return checkin_date
	end
	
	def self.get_listings(latitude, longitude)
		# Get listings
		offset = 0
		response = HTTParty.get("https://api.airbnb.com/v1/listings/search?client_id=3092nxybyb0otqw18e8nh5nty&items_per_page=10&offset=#{offset}&lat=#{latitude}&lng=#{longitude}")
    	Listing.parse_listings(response.parsed_response["listings"])
    	if response.success?
    		listings_count = response.parsed_response["listings_count"]
    		offset += 10
    		searches_without_results = 0
    		while offset < listings_count && offset < 1000
	    		response = HTTParty.get("https://api.airbnb.com/v1/listings/search?client_id=3092nxybyb0otqw18e8nh5nty&items_per_page=10&offset=#{offset}&lat=#{latitude}&lng=#{longitude}")
	    		
	    		if Listing.parse_listings(response.parsed_response["listings"])
	    			searches_without_results = 0
	    		else
	    			searches_without_results += 1
	    		end
	    		
	    		if searches_without_results > 5
	    			break
	    		end
	    		
	    		offset += 10
    		end
    	end
	end

	def self.parse_listings(listings)
		any_listings = false
		listings.each { |listing|
			if !Listing.exists?(:airbnb_id => listing["listing"]["id"].to_s)
				any_listings = true
				Listing.create(
					:airbnb_id => listing["listing"]["id"].to_s,
					:airbnb_user_id => listing["listing"]["user"]["user"]["id"].to_s,
					:city => listing["listing"]["city"],
					:latitude => listing["listing"]["lat"],
					:longitude => listing["listing"]["lng"],
					:country => listing["listing"]["country"],
					:zipcode => listing["listing"]["zipcode"],
					:address => listing["listing"]["address"],
					:state => listing["listing"]["state"],
					:first_name => listing["listing"]["user"]["user"]["first_name"],
					:picture_url => listing["listing"]["user"]["user"]["picture_url"],
					:thumbnail_url => listing["listing"]["user"]["user"]["thumbnail_url"])
			end
		}
		return any_listings
	end

	def self.disassociate_listings
		Listing.where.not(:account_id => nil).each { |listing|
			listing.update_attributes(:account_id => nil)
		}
	end

	def claim_listing
		if self.account_id != nil
			return
		end

		peer_listings = Listing.where(:airbnb_user_id => self.airbnb_user_id)
		account = nil

		# See if any peer listings have accounts already
		peer_listings.each { |peer_listing|
			if peer_listing.account_id != nil
				account = peer_listing.account
				break
			end
		}

		if account == nil
			unclaimed_accounts = Account.where("num_claimed < ?", Account::MAX_NUM_CLAIMED)
			if unclaimed_accounts.length == 0
				account = Account.create_airbnb_account
			else
				account = unclaimed_accounts.first
			end
		end
		peer_listings.each { |peer_listing|
			if peer_listing.account_id != account.id
				peer_listing.update_attributes(:account_id => account.id)
			end
		}

		self.update_attributes(:account_id => account.id)
		account.update_attributes(:num_claimed => (account.num_claimed + 1))
	end
end
