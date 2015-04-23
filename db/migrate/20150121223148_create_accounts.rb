class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :email
      t.string :access_token

      t.timestamps
    end
  end
end
