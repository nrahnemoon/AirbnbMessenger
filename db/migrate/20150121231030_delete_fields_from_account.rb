class DeleteFieldsFromAccount < ActiveRecord::Migration
	def up
		remove_column :accounts, :first_name
		remove_column :accounts, :last_name
		remove_column :accounts, :password
	end

	def down
		add_column :accounts, :first_name, :string
		add_column :accounts, :last_name, :string
		add_column :accounts, :password, :string
	end
end
