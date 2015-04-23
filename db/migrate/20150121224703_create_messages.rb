class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.datetime :checkout_date
      t.datetime :checkin_date
      t.string :listing_id
      t.string :listing_picture_url
      t.string :listing_first_name

      t.timestamps
    end
  end
end
