class AddDropReferencesToDelivery < ActiveRecord::Migration
  def change
  	add_column :deliveries, :drop_id, :integer
  end
end
