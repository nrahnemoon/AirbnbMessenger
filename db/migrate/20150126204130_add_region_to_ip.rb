class AddRegionToIp < ActiveRecord::Migration
  def up
		add_column :ips, :region, :string
	end

	def down
		remove_column :ips, :region
	end
end
