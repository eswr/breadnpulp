class AddPricesToPacks < ActiveRecord::Migration
  def change
  	add_column :packs, :unit_price, :integer
  end
end
