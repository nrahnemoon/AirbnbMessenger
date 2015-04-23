class AddNumClaimedToAccount < ActiveRecord::Migration
	def up
		add_column :accounts, :num_claimed, :integer
	end

	def down
		remove_column :accounts, :num_claimed
	end
end
