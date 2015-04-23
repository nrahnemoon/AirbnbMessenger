class ModifyMessagesColumnsMore < ActiveRecord::Migration
	def up
		change_column :messages, :airbnb_thread_id, :string
		change_column :messages, :listing_id, :integer, :limit => nil
	end

	def down
		change_column :messages, :airbnb_thread_id, :integer
		change_column :messages, :listing_id, :integer
	end
end
