class AddFieldsToAccount < ActiveRecord::Migration
	def up
		add_column :accounts, :first_name, :string
		add_column :accounts, :last_name, :string
		add_column :accounts, :password, :string
		add_column :accounts, :picture_url, :string
		add_column :accounts, :thumbnail_url, :string
	end

	def down
		remove_column :accounts, :first_name
		remove_column :accounts, :last_name
		remove_column :accounts, :password
		remove_column :accounts, :picture_url
		remove_column :accounts, :thumbnail_url
	end
end
