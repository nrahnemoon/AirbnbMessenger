class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :airbnb_id

      t.timestamps
    end
  end
end
