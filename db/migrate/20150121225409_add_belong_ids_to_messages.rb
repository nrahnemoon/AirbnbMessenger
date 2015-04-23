class AddBelongIdsToMessages < ActiveRecord::Migration
  def up
		add_column :messages, :account_message_limit_id, :integer
		add_column :messages, :account_id, :integer
	end

	def down
		remove_column :messages, :account_message_limit_id
		remove_column :messages, :account_id
	end
end
