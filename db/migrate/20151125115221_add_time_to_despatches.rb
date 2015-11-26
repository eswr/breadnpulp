class AddTimeToDespatches < ActiveRecord::Migration
  def change
  	add_column :despatches, :despatch_time, :time
  end
end
