class AddKickerrSizeDescriptionToKickerrs < ActiveRecord::Migration
  def change
  	add_column :kickerrs, :size_description, :string
  end
end
