class AddDefaultNumClaimedToAccount < ActiveRecord::Migration
	def up
		change_column :accounts, :num_claimed, :integer, :default => 0
	end

	def down
		change_column :accounts, :num_claimed, :integer
	end
end
