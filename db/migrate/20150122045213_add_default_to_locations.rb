class AddDefaultToLocations < ActiveRecord::Migration
 	def up
		change_column :locations, :searched, :boolean, :default => false
	end

	def down
		change_column :locations, :searched, :boolean
	end
end
