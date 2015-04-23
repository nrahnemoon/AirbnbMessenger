class EditColumnsInMessages < ActiveRecord::Migration
	def up
		remove_column :messages, :account_message_limit_id
		remove_column :messages, :account_id
		remove_column :messages, :listing_first_name
		remove_column :messages, :listing_picture_url
		add_column :messages, :airbnb_thread_id, :integer
	end

	def down
		add_column :messages, :account_message_limit_id, :integer
		add_column :messages, :account_id, :integer
		add_column :messages, :listing_first_name, :string
		add_column :messages, :listing_picture_url, :string
		remove_column :messages, :airbnb_thread_id
	end
end
