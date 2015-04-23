class AddAirbnbIdToAccount < ActiveRecord::Migration
	def up
		add_column :accounts, :airbnb_id, :string
	end

	def down
		remove_column :accounts, :airbnb_id
	end
end
