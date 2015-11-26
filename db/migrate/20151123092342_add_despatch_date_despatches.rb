class AddDespatchDateDespatches < ActiveRecord::Migration
  def change
  	add_column :despatches, :despatch_date, :date
  end
end
