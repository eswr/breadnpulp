class AddDespatchIdToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :despatch_id, :integer
  end
end
