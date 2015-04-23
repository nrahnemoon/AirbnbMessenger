class ModifyMessagesColumns < ActiveRecord::Migration
  	def up
		remove_column :messages, :checkin_date
		remove_column :messages, :checkout_date
		change_column :messages, :listing_id, :integer
	end

	def down
		add_column :messages, :checkin_date, :datetime
		add_column :messages, :checkout_date, :datetime
		change_column :messages, :listing_id, :string
	end
end
