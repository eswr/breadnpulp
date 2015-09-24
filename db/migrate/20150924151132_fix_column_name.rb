class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :deliveries, :on, :delivery_date
  end
end
