class AddMessageSentToListing < ActiveRecord::Migration
	def up
		add_column :listings, :intro_sent, :boolean, default: false
	end

	def down
		remove_column :listings, :intro_sent
	end
end
