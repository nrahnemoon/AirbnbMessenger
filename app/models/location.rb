class Location < ActiveRecord::Base

	def self.load_csv
		csv_text = File.read(Rails.root.join("db", "cityzip.csv"))
		csv = CSV.parse(csv_text, :headers => true)
		csv.each do |row|
			Location.create!(row.to_hash)
		end
	end

	def self.get_listings
		unsearched_locations = Location.where(:searched => false, :skipped => false)
		unsearched_locations.each { |location|
			searched = Location.where("longitude > ? AND longitude < ? AND latitude > ? AND latitude < ? AND searched == ?",
				location.longitude - 0.05,
				location.longitude + 0.05,
				location.latitude - 0.05,
				location.latitude + 0.05,
				true)
			if searched.length > 0
				location.update_attributes(:skipped => true)
			else
				Listing.get_listings(location.latitude.to_s, location.longitude.to_s)
				location.update_attributes(:searched => true)
			end
		}
	end
end
