class AddRowsToLocations < ActiveRecord::Migration
	def up
		add_column :locations, :searched, :boolean
	end

	def down
		remove_column :locations, :searched
	end
end
