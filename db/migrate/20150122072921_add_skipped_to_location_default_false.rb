class AddSkippedToLocationDefaultFalse < ActiveRecord::Migration
	def up
		change_column :locations, :skipped, :boolean, :default => false
	end

	def down
		change_column :locations, :skipped, :boolean
	end
end
