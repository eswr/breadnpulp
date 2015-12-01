class AddKickerrSizeToKickerrs < ActiveRecord::Migration
  def change
  	add_column :kickerrs, :kickerr_size, :string
  end
end
