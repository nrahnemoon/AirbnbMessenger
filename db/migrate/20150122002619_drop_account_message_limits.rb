class DropAccountMessageLimits < ActiveRecord::Migration
  def change
  	drop_table :account_message_limits
  end
end
