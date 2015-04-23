class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :state
      t.string :city
      t.integer :postal
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
