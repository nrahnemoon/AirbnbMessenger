class AddAccountIdToMessageLimit < ActiveRecord::Migration
  def up
		add_column :account_message_limits, :account_id, :integer
	end

	def down
		remove_column :account_message_limits, :account_id
	end
end
