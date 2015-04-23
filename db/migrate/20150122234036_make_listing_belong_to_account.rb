class MakeListingBelongToAccount < ActiveRecord::Migration
	def up
		add_column :listings, :account_id, :integer
	end

	def down
		remove_column :listings, :account_id
	end
end
