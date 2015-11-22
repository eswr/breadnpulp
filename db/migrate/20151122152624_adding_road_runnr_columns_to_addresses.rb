class AddingRoadRunnrColumnsToAddresses < ActiveRecord::Migration
  def change
  	add_column :addresses, :locality, :string
  	add_column :addresses, :city, :string
  end
end
