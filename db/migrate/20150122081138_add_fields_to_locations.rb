class AddFieldsToLocations < ActiveRecord::Migration
	def up
		add_column :listings, :airbnb_user_id, :string
		add_column :listings, :city, :string
		add_column :listings, :latitude, :decimal
		add_column :listings, :longitude, :decimal
		add_column :listings, :country, :string
		add_column :listings, :zipcode, :string
		add_column :listings, :address, :string
		add_column :listings, :state, :string
		add_column :listings, :first_name, :string
	end

	def down
		remove_column :listings, :airbnb_user_id
		remove_column :listings, :city
		remove_column :listings, :latitude
		remove_column :listings, :longitude
		remove_column :listings, :country
		remove_column :listings, :zipcode
		remove_column :listings, :address
		remove_column :listings, :state
		remove_column :listings, :first_name
	end
end
