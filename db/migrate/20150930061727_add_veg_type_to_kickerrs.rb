class AddVegTypeToKickerrs < ActiveRecord::Migration
  def change
  	add_column :kickerrs, :veg_type, :string
  end
end
