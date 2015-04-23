class AddSkippedToLocation < ActiveRecord::Migration
  	def up
		add_column :locations, :skipped, :boolean
	end

	def down
		remove_column :locations, :skipped
	end
end
