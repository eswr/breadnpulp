class AddressChangesToDrops < ActiveRecord::Migration
  def change
  	remove_column :drops, :address_id, :integer
  	add_column :drops, :drop_address, :string
  end
end
