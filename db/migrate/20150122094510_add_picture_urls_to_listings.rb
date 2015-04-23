class AddPictureUrlsToListings < ActiveRecord::Migration
  def up
		add_column :listings, :picture_url, :string
		add_column :listings, :thumbnail_url, :string
	end

	def down
		remove_column :listings, :picture_url
		remove_column :listings, :city
	end
end
